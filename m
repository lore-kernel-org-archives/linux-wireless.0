Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37513 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682Ab1CQVu4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 17:50:56 -0400
Received: by qwk3 with SMTP id 3so2421036qwk.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2011 14:50:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300284739-7797-4-git-send-email-lemenkov@gmail.com>
References: <1300284739-7797-1-git-send-email-lemenkov@gmail.com>
	<1300284739-7797-4-git-send-email-lemenkov@gmail.com>
Date: Thu, 17 Mar 2011 22:50:55 +0100
Message-ID: <AANLkTikSJAyB3Zz-MSJEZsDMt_K81isNpV5nhVakCZYX@mail.gmail.com>
Subject: Re: [rt2x00-users] [PATCH 3/4] rt2x00: Add 2L Central Europe BV 8070
 under CONFIG_RT2800USB_UNKNOWN
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
>  drivers/net/wireless/rt2x00/rt2800usb.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 1f2ea95..3aa32fd 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -937,6 +937,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        { USB_DEVICE(0x07d1, 0x3c13), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x07d1, 0x3c15), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x07d1, 0x3c17), USB_DEVICE_DATA(&rt2800usb_ops) },
> +       /* Edimax */
> +       { USB_DEVICE(0x7392, 0x4085), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* Encore */
>        { USB_DEVICE(0x203d, 0x14a1), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* Gemtek */
> --
> 1.7.4
>
>
> _______________________________________________
> users mailing list
> users@rt2x00.serialmonkey.com
> http://rt2x00.serialmonkey.com/mailman/listinfo/users_rt2x00.serialmonkey.com
>
