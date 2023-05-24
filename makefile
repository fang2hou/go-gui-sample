FONTS := $(wildcard fonts/*.ttf)
GENERATED_FONTS := $(patsubst fonts/%.ttf, internal/font/%.go, $(FONTS))

CMDS := $(wildcard cmd/*)
TARGETS_WIN := $(patsubst cmd/%, bin/windows/%.exe, $(CMDS))
TARGETS_MAC := $(patsubst cmd/%, bin/darwin/%, $(CMDS))

.PHONY: all update-fonts init build-win build-mac release clean clean-fonts

all: prepare update-fonts build-win build-mac
	@printf "🎉 All build tasks done! すべてのビルドタスクが完了しました!\n"

update-fonts: download-m-plus-fonts $(GENERATED_FONTS)

download-m-plus-fonts:
	@if [ -z "$(FONTS)" ]; then \
  		printf "📥 Downloading fonts... フォントをダウンロードしています...\n"; \
		curl -sL https://github.com/coz-m/MPLUS_FONTS/raw/master/fonts/ttf/Mplus2-Regular.ttf -o fonts/Mplus2-Regular.ttf; \
		curl -sL https://github.com/coz-m/MPLUS_FONTS/raw/master/fonts/ttf/Mplus2-Bold.ttf -o fonts/Mplus2-Bold.ttf; \
		$(MAKE) update-fonts; \
	fi

internal/font/%.go: fonts/%.ttf
	@printf "📁 Processing $<... $<を処理しています...\n"
	@fyne bundle $< > $@
	@sed -i '' '1,10s/package main/package font/' $@
	@sed -i '' 's/var resource/var Resource/g' $@

prepare:
	@printf "🛠️ Preparing development environment... 開発環境を準備しています...\n"
	@go get -u fyne.io/fyne/v2
	@go install fyne.io/fyne/v2/cmd/fyne@latest
	@go mod tidy

run:
	@printf "🚀 Launching application... アプリケーションを起動しています...\n"
	@go run ./cmd/japanese-gui

build-win: update-fonts $(TARGETS_WIN)

build-mac: update-fonts $(TARGETS_MAC)

bin/windows/%.exe: cmd/%
	@printf "📦 [%s] Building Windows binary... Windowsバイナリをビルドしています...\n" $<
	@if [ -z "$(shell which x86_64-w64-mingw32-gcc)" ]; then \
		printf "🚫 x86_64-w64-mingw32-gcc not found. Please install it first. x86_64-w64-mingw32-gccが見つかりません。先にインストールしてください。\n"; \
		printf "🍺 brew install mingw-w64\n"; \
		exit 1; \
	fi
	@CGO_ENABLED=1 CC=x86_64-w64-mingw32-gcc GOOS=windows GOARCH=amd64 go build -ldflags -H=windowsgui -o $@ ./$<

bin/darwin/%: cmd/%
	@printf "📦 [%s] Building macOS binary... macOSバイナリをビルドしています...\n" $<
	@go build -o $@ ./$<

clean:
	@printf "🗑️ Removing all generated files... 生成されたファイルを削除しています...\n"
	@rm -rf internal/font/*.go
	@rm -rf bin

clean-fonts:
	@printf "🗑️ Removing all downloaded fonts... ダウンロードされたフォントを削除しています...\n"
	@rm fonts/Mplus2-Regular.ttf
	@rm fonts/Mplus2-Bold.ttf

release:
	@$(MAKE) clean
	@$(MAKE) clean-fonts
	@$(MAKE) all
	@rm -rf dist
	@mkdir -p dist
	@printf "✳️ [japanese-gui] Creating release app... リリースアプリを作成しています...\n"
	@fyne package -os darwin -icon assets/icon.png -executable ./bin/darwin/japanese-gui -name "Japanese GUI" -appID "com.fang2hou.japanesegui" -appVersion 0.0.1 -release
	@mv Japanese\ GUI.app dist/
	@cp bin/windows/japanese-gui.exe dist/
	@cp assets/icon.ico cmd/japanese-gui/app.ico
	@echo 'ID ICON "app.ico"' > cmd/japanese-gui/app.rc
	@cd cmd/japanese-gui && x86_64-w64-mingw32-windres -O coff app.rc -o app.syso
	@cd cmd/japanese-gui && CC=x86_64-w64-mingw32-gcc GOARCH=amd64 fyne package -os windows -icon ../../assets/icon.png -executable ../../dist/japanese-gui.exe -name "Japanese GUI" -appID japanese-gui.exe -appVersion 0.0.1
	@cd cmd/japanese-gui && rm app.ico app.rc app.syso
	@printf "🎉 [japanese-gui] Release app created! リリースアプリが作成されました!\n"