Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38106 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444Ab2CEIsv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 03:48:51 -0500
Received: by vbbff1 with SMTP id ff1so3204276vbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 05 Mar 2012 00:48:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAD2nsn1Wu66JUaPQmK4ktjUBeCjMp4xXG2=FDy3G-LnVDwtAVA@mail.gmail.com>
References: <CALx5=V8BDFXD7KGBFia0MAkb2iv3x5dupGXTkKEDJ24DLJVx1g@mail.gmail.com>
	<CAD2nsn2GLAo=8xhe+-Xm0igSmQ+tr1F+Q6scuFaeaQWMYrQbwg@mail.gmail.com>
	<CALx5=V9LwpWVG0UGLgyNyJVrSYj826xXwbEcFQVYM5BxAxnEJQ@mail.gmail.com>
	<CAD2nsn1Wu66JUaPQmK4ktjUBeCjMp4xXG2=FDy3G-LnVDwtAVA@mail.gmail.com>
Date: Mon, 5 Mar 2012 14:18:50 +0530
Message-ID: <CAD2nsn2wexoWksvvt-5oixpVEeAEybR5febwA1sf3jnxGh5g0g@mail.gmail.com> (sfid-20120305_094902_281425_0EE52D94)
Subject: Re: [ath9k-devel] Any recommendation of direct access the GPIO from
 specific address ?
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Matt Chen <machen@suse.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 5, 2012 at 2:14 PM, Mohammed Shafi <shafi.wireless@gmail.com> wrote:
> Hi Matt,
>
>> echo 0x404c to which file in /sys/kernel/debug/ath9k ?
>
> root@shafi-laptop:/sys/kernel/debug/ieee80211/phy0/ath9k# echo 0x404c > regidx
> root@shafi-laptop:/sys/kernel/debug/ieee80211/phy0/ath9k# cat regval
> 0x00000c45
> root@shafi-laptop:/sys/kernel/debug/ieee80211/phy0/ath9k# cat regval
> 0x00000c45
>
> -> toggle the rfkill button, wifi off
>
> root@shafi-laptop:/sys/kernel/debug/ieee80211/phy0/ath9k# cat regval
> 0x00000c55
> root@shafi-laptop:/sys/kernel/debug/ieee80211/phy0/ath9k#
> root@shafi-laptop:/sys/kernel/debug/ieee80211/phy0/ath9k# cat regval
> 0x00000c55
> root@shafi-laptop:/sys/kernel/debug/ieee80211/phy0/ath9k# cat regval
> 0x00000c55
>
> -> toggle the rfkill button, wifi ON
>
> root@shafi-laptop:/sys/kernel/debug/ieee80211/phy0/ath9k# cat regval
> 0x00000c45
> root@shafi-laptop:/sys/kernel/debug/ieee80211/phy0/ath9k# cat regval
> 0x00000c45
>
> please also see the dump of rfkill list, as i am external PCI card, my
> card is only softblocked.

please note my chip is AR9462, (AR9300 family)

>
> --
> thanks,
> shafi



-- 
thanks,
shafi
