FONTS := $(wildcard fonts/*.ttf)
GENERATED_FONTS := $(patsubst fonts/%.ttf, internal/font/%.go, $(FONTS))

CMDS := $(wildcard cmd/*)
TARGETS_WIN := $(patsubst cmd/%, bin/windows/%.exe, $(CMDS))
TARGETS_MAC := $(patsubst cmd/%, bin/darwin/%, $(CMDS))

.PHONY: all update-fonts init build-win build-mac

all: prepare update-fonts build-win build-mac
	@printf "🎉 All tasks done! すべてのタスクが完了しました!\n"

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
	@go run ./cmd/convertor

build-win: update-fonts $(TARGETS_WIN)

build-mac: update-fonts $(TARGETS_MAC)

bin/windows/%.exe: cmd/%
	@printf "📦 Building Windows binary... Windowsバイナリをビルドしています...\n"
	@CGO_ENABLED=1 CC=x86_64-w64-mingw32-gcc GOOS=windows GOARCH=amd64 go build -ldflags -H=windowsgui -o $@ ./$<

bin/darwin/%: cmd/%
	@printf "📦 Building macOS binary... macOSバイナリをビルドしています...\n"
	@go build -o $@ ./$<

clean:
	@printf "🗑️ Removing all generated files... 生成されたファイルを削除しています...\n"
	@rm -rf internal/font/*.go
	@rm -rf bin

clean-fonts:
	@printf "🗑️ Removing all downloaded fonts... ダウンロードされたフォントを削除しています...\n"
	@rm fonts/Mplus2-Regular.ttf
	@rm fonts/Mplus2-Bold.ttf