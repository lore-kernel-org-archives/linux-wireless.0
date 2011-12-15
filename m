Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45791 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab1LOFsX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 00:48:23 -0500
Received: by vcbfk14 with SMTP id fk14so1243356vcb.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Dec 2011 21:48:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKeTQ4aVzp3GTmzR0zv1j5fWyCUrQLUk9EHHBvZFpDYiQSC1=g@mail.gmail.com>
References: <CAKeTQ4aVzp3GTmzR0zv1j5fWyCUrQLUk9EHHBvZFpDYiQSC1=g@mail.gmail.com>
Date: Thu, 15 Dec 2011 11:18:22 +0530
Message-ID: <CAD2nsn0jgoUDf02UrajQyOKZiETMEbP6ikBAtBNdmcgT6m34yw@mail.gmail.com> (sfid-20111215_064826_511188_C6013E0B)
Subject: Re: wierless hardware using ath9k driver on AP mode leads to kernel panic
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Ashwin Mendonca <ashwinloyal@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 14, 2011 at 10:53 PM, Ashwin Mendonca <ashwinloyal@gmail.com> wrote:
> I can enable AP mode on my netbook. But when I turn on a wireless
> client device, then the sytem on AP mode freezes. It has happened
> since 2.3.38. When I installaed ath9k driver compiled from
> compat-wireless on linux 2.3.38, the issue got disappered. But the
> ath9k driver packed with the kernel still has the issue. On Ubuntu
> 11.10, all linux 3.0 releases (the current stable release  Ubuntu
> 3.0.14) have the issue. I compiled 3.1.5 stable kernel from sources,
> which also has the issue. I recently compiled
> compat-wireless-3.2-rc1-1, which also got my system frozen. This is
> the bug that I filled at Launchpad:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/875503

some time back the STA mode itself had this issue, but was fixed by
https://lkml.org/lkml/2011/4/12/269
could you please let us know whether this issue happens in
http://linuxwireless.org/en/users/Download#Where_to_download_bleeding_edge

i just tried to put AR2427 in AP mode and then connected a STA, did
not seem to cause any issue in 3.2.0-rc5-wl. please also post your
hostapd.conf and your hostapd --version


> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
shafi
