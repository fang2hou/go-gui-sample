package main

import (
	"fyne.io/fyne/v2"
	"fyne.io/fyne/v2/app"
	"fyne.io/fyne/v2/container"
	"fyne.io/fyne/v2/layout"
	"fyne.io/fyne/v2/widget"
)

func main() {
	a := app.New()
	a.Settings().SetTheme(&customTheme{})
	w := a.NewWindow("日本語")
	w.Resize(fyne.NewSize(300, 200))
	w.SetContent(
		container.New(
			layout.NewVBoxLayout(),
			layout.NewSpacer(),
			widget.NewLabel("Normal Label ノーマルラベルです。"),
			layout.NewSpacer(),
			widget.NewLabelWithStyle("Bold Label 太字ラベルです。", fyne.TextAlignLeading, fyne.TextStyle{Bold: true}),
			layout.NewSpacer(),
		),
	)
	w.ShowAndRun()
}
