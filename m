Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40330 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab1CQVul convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 17:50:41 -0400
Received: by qyk7 with SMTP id 7so327672qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2011 14:50:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300284739-7797-3-git-send-email-lemenkov@gmail.com>
References: <1300284739-7797-1-git-send-email-lemenkov@gmail.com>
	<1300284739-7797-3-git-send-email-lemenkov@gmail.com>
Date: Thu, 17 Mar 2011 22:50:40 +0100
Message-ID: <AANLkTintw9gvnQGaN185r24u+yRrdQ+pKEU+uuHHrkWQ@mail.gmail.com>
Subject: Re: [rt2x00-users] [PATCH 2/4] rt2x00: Add Planex Communications,
 Inc. RT8070 under CONFIG_RT2800USB_UNKNOWN
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Peter Lemenkov <lemenkov@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@redhat.com>,
	rt2x00-dev <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 16, 2011 at 3:12 PM, Peter Lemenkov <lemenkov@gmail.com> wrote:
> Signed-off-by: Peter Lemenkov <lemenkov@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 03a5308..1f2ea95 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -961,6 +961,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        { USB_DEVICE(0x1d4d, 0x0010), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x1d4d, 0x0011), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* Planex */
> +       { USB_DEVICE(0x2019, 0x5201), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x2019, 0xab24), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* Qcom */
>        { USB_DEVICE(0x18e8, 0x6259), USB_DEVICE_DATA(&rt2800usb_ops) },
> --
> 1.7.4
>
>
> _______________________________________________
> users mailing list
> users@rt2x00.serialmonkey.com
> http://rt2x00.serialmonkey.com/mailman/listinfo/users_rt2x00.serialmonkey.com
>
