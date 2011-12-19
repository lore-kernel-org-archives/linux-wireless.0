Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38977 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab1LSVfK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 16:35:10 -0500
Received: by eekc4 with SMTP id c4so5859857eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Dec 2011 13:35:09 -0800 (PST)
References: <20111219210724.27454.1642.stgit@bob.linux.org.uk>
In-Reply-To: <20111219210724.27454.1642.stgit@bob.linux.org.uk>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <C981C123-844A-4A16-8CD6-6C836E0C2974@gmail.com> (sfid-20111219_223514_379183_DF870CBE)
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ivdoorn@gmail.com" <ivdoorn@gmail.com>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2800: Add support for the Fujitsu Stylistic Q550
Date: Mon, 19 Dec 2011 22:35:08 +0100
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 dec. 2011, at 22:07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> From: Alan Cox <alan@linux.intel.com>
> 
> Just another USB identifier.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
> 
> drivers/net/wireless/rt2x00/rt2800usb.c |    2 ++
> 1 files changed, 2 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index f156579..9e5556c 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -1158,6 +1158,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
>    { USB_DEVICE(0x7392, 0x7722) },
>    /* Encore */
>    { USB_DEVICE(0x203d, 0x14a1) },
> +    /* Fujitsu Stylistic 550 */
> +    { USB_DEVICE(0x1690, 0x0761) },
>    /* Gemtek */
>    { USB_DEVICE(0x15a9, 0x0010) },
>    /* Gigabyte */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
