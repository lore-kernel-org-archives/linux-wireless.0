Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:59726 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141Ab3HPHFH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 03:05:07 -0400
Received: from [192.168.2.100] ([93.218.73.165]) by mail.gmx.com (mrgmx103)
 with ESMTPSA (Nemesis) id 0M4GND-1W15au0gfj-00rsjA for
 <linux-wireless@vger.kernel.org>; Fri, 16 Aug 2013 09:05:05 +0200
Message-ID: <520DCF1E.7040808@rempel-privat.de> (sfid-20130816_090511_937672_8BBB4B28)
Date: Fri, 16 Aug 2013 09:05:02 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Christian Gagneraud <chgans@gna.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [TL-WN721N] No disconnect notification when AP is gone
References: <520D6058.7040405@gna.org>
In-Reply-To: <520D6058.7040405@gna.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 16.08.2013 01:12, schrieb Christian Gagneraud:
> Hi there,
>
> I'm using a TP-LINK TL-WN721N, and experience a strange behaviour, I'm
> running Ubuntu 13.04 (3.8.0-27-generic + backports-3.11-rc3-1).
>
> The problem is that if I am connected to my AP and then power it off, I
> never receive a disconnect notification.
>
> I first reported the bug to the connman mailing list [1], but it was
> suggested there that it could be a bug in the device driver.
>
> At first I was using the Ubuntu kernel modules, but before reporting any
> bugs, I switched to backports-3.11-rc3-1, and I still have the problem.
>
> Any thoughts?
>
> Regards,
> Chris
>
> [1] Latest messages haven't been archived  yet, but:
>   https://lists.connman.net/pipermail/connman/2013-August/015401.html

I assume it is Atheros ar9271 based adapter. Did you tried to use latest 
firmware?
https://github.com/qca/open-ath9k-htc-firmware

If you have some time, i'll suggest you to investigate this issue so far 
you can by your self.

-- 
Regards,
Oleksij
