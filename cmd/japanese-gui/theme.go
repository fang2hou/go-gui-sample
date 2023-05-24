package main

import (
	"fyne.io/fyne/v2"
	"fyne.io/fyne/v2/theme"
	"image/color"

	"go-gui-sample/internal/font"
)

type customTheme struct{}

var _ fyne.Theme = (*customTheme)(nil)

// Font return bundled font resource
func (*customTheme) Font(s fyne.TextStyle) fyne.Resource {
	if !s.Italic {
		if s.Bold {
			return font.ResourceMplus2BoldTtf
		}

		return font.ResourceMplus2RegularTtf
	}

	return theme.DefaultTheme().Font(s)
}

func (*customTheme) Color(n fyne.ThemeColorName, v fyne.ThemeVariant) color.Color {
	return theme.DefaultTheme().Color(n, v)
}

func (*customTheme) Icon(n fyne.ThemeIconName) fyne.Resource {
	return theme.DefaultTheme().Icon(n)
}

func (*customTheme) Size(n fyne.ThemeSizeName) float32 {
	return theme.DefaultTheme().Size(n)
}
