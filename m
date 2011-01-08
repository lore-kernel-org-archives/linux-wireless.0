Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42852 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab1AHKow convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Jan 2011 05:44:52 -0500
Received: by iyi12 with SMTP id 12so16464960iyi.19
        for <linux-wireless@vger.kernel.org>; Sat, 08 Jan 2011 02:44:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <7A94256FD72B884D9E7C55586C3CBCEE13CD2B113F@SJEXCHCCR01.corp.ad.broadcom.com>
References: <AANLkTikam0zcxe00UCT4BDQMmrJcPKf1Hbt6=PBokpga@mail.gmail.com> <7A94256FD72B884D9E7C55586C3CBCEE13CD2B113F@SJEXCHCCR01.corp.ad.broadcom.com>
From: Jamie Kitson <jamie@kitten-x.com>
Date: Sat, 8 Jan 2011 10:44:31 +0000
Message-ID: <AANLkTimkgrc19QCdeOhc+huTsrGCD_Y8cqHnz_dQjc5y@mail.gmail.com>
Subject: Re: Kernel Panic wlc_mac80211.c Line 6093
To: Brett Rudley <brudley@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Hmm, haven't seen this type of crash before.  Any special setup you are using?

Not that I can think of. I still have the Broadcom STA compiled wl
driver installed but disabled. I installed the brcm80211 driver from
Arch's AUR repository:

http://aur.archlinux.org/packages.php?ID=42670

I have recently been fiddling about with laptop-mode, but I don't
think that has caused it as that doesn't reproduce it and there's been
no obvious acpi event when it's crashed.

Cheers, Jamie
