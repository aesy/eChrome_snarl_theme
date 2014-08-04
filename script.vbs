
Function style_Init()
  ' // provide information about our style
  With style.info
    .format = "display"
    .name = "eChrome"
    .description = "Clean, chrome-like notifications"
    .version = 0
    .revision = 1
    .icon = style.path & "icon.png"
    .schemes = "Default;Resizable"
  End With
End Function

Sub style_Draw()
Dim pbIcon
Dim xEdge
Dim sz
Dim prTitle
Dim prText
Dim lc

Const TITLE_TEXT_GAP = 5
Const MARGIN_SIZE = 5
Const POPUP_WIDTH = 400
Const ICON_SIZE = 80

  Set prTitle = new_BRect(0,0,0,0)
  Set prText = new_BRect(0,0,0,0)

  With view
    .SizeTo POPUP_WIDTH, ICON_SIZE
    Set pbIcon = load_image_obj(style.notification.ValueOf("icon"))

    xEdge = MARGIN_SIZE
    If is_valid_image((pbIcon)) Then
      xEdge = xEdge + ICON_SIZE
    End If

    If style.notification.ValueOf("title") <> "" Then
      .SetFont "Segoe UI", 10
      .MeasureString style.notification.ValueOf("title"), new_BRect(xEdge, 0, .Width - MARGIN_SIZE, 16384), (prTitle)
    End If

    If style.notification.ValueOf("text") <> "" Then
      .SetFont "Segoe UI", 9
      Select Case style.notification.ValueOf("scheme")
      Case "resizable"
        .MeasureString style.notification.ValueOf("text"), new_BRect(xEdge, 0, .Width - MARGIN_SIZE, 16384), (prText)
      Case Else
        .MeasureString style.notification.ValueOf("text"), new_BRect(xEdge, 0, .Width - MARGIN_SIZE, ICON_SIZE - MARGIN_SIZE*2 - prTitle.Height - TITLE_TEXT_GAP), (prText)
      End Select
    End If

    ' /* final size */

    Select Case style.notification.ValueOf("scheme")
    Case "resizable"
      .SizeTo POPUP_WIDTH, MARGIN_SIZE*2 + prTitle.Height + TITLE_TEXT_GAP + prText.Height
    Case Else
      .SizeTo POPUP_WIDTH, ICON_SIZE
    End Select

    ' /* background */

    .EnableSmoothing True
    .TextMode = 4	'// MFX_TEXT_ANTIALIAS

    .SetHighColour rgba(250, 250, 250)
    .FillRoundRect .Bounds, 4, 4

    ' /* title */

    .SetFont "Segoe UI", 10
    .SetHighColour rgba(0, 0, 0)

    prTitle.OffsetBy 0, MARGIN_SIZE
    .DrawString style.notification.ValueOf("title"), (prTitle), 0

    ' /* text */

    .SetFont "Segoe UI", 9
    .SetHighColour rgba(0, 0, 0)

    prText.OffsetBy 0, MARGIN_SIZE + prTitle.Height + TITLE_TEXT_GAP
    .DrawString style.notification.ValueOf("text"), (prText), 0

    ' /* icon */

    .DrawScaledImage (pbIcon), new_BPoint(0, 0), new_BPoint(ICON_SIZE, ICON_SIZE)

    ' /* priority */

    If string_as_long(style.notification.ValueOf("priority")) > 0 Then
      .SetHighColour rgba(236, 59, 0, 220)
      .SetPenSize 2
      .StrokeRect .Bounds
    Else
      .SetHighColour rgba(127, 127, 127, 127)
      .SetPenSize 1
      .StrokeRect .Bounds
    End If

  End With
End Sub