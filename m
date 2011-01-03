Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33542 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab1ACPE5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jan 2011 10:04:57 -0500
Received: by eye27 with SMTP id 27so5938920eye.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jan 2011 07:04:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <651997.51284.qm@web31502.mail.mud.yahoo.com>
References: <651997.51284.qm@web31502.mail.mud.yahoo.com>
Date: Mon, 3 Jan 2011 23:04:56 +0800
Message-ID: <AANLkTimk8pnx3F+pwVTZ6sA+=-_h+4u+i=YTzp05Qf=A@mail.gmail.com>
Subject: Re: Tp-link wn7200nd - cannot associate
From: Chin Shi Hong <cshong87@gmail.com>
To: Ming-Ching Tiew <mctiew@yahoo.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 3, 2011 at 10:38 AM, Ming-Ching Tiew <mctiew@yahoo.com> wrote:
>
> I have a TP-LINK WN7200ND, I am tested it with Kernel 2.6.36.1 and 2.6.35.10, basically after inserting the USB, the interface is up and it can never associate with any access point.
>
> #lsmod |grep rt2
>
> rt2800usb               7632  0
> rt2800lib              20328  1 rt2800usb
> rt2x00usb               4628  2 rt2800usb,rt2800lib
> rt2x00lib              15408  2 rt2800lib,rt2x00usb
> mac80211              122068  2 rt2x00usb,rt2x00lib
> cfg80211               92252  2 rt2x00lib,mac80211
>
> There are a lot of similar complaints on the net, this is one example :-
>
> http://ubuntuforums.org/showthread.php?t=1530095
>
> There don't seem to be any issue with 'iwlist wlanX scan'. But just can't associate.
>
> Any recommendation ? Any debug information I should provide ?
>
> Regards
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Good luck with you. My rt3090 also not work on 64 bit ubuntu but work
on 32 bit ubuntu.

You use Ubuntu is it? Which version? 32-bit or 64-bit version?

And, can you access internet through wired connection?

Regards,
