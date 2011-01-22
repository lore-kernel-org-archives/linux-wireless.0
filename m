Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60891 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab1AVLMZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Jan 2011 06:12:25 -0500
Received: by iyj18 with SMTP id 18so2506313iyj.19
        for <linux-wireless@vger.kernel.org>; Sat, 22 Jan 2011 03:12:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTingheCkPNvc+8qM5oQh8NHPAX2h4Z6C1YZEFRBc@mail.gmail.com>
References: <AANLkTikam0zcxe00UCT4BDQMmrJcPKf1Hbt6=PBokpga@mail.gmail.com>
 <7A94256FD72B884D9E7C55586C3CBCEE13CD2B113F@SJEXCHCCR01.corp.ad.broadcom.com>
 <AANLkTimkgrc19QCdeOhc+huTsrGCD_Y8cqHnz_dQjc5y@mail.gmail.com>
 <AANLkTimERVKAz90zPa8e_gikAf3e4G8nwjHHYrK9qsFT@mail.gmail.com> <AANLkTingheCkPNvc+8qM5oQh8NHPAX2h4Z6C1YZEFRBc@mail.gmail.com>
From: Jamie Kitson <jamie@kitten-x.com>
Date: Sat, 22 Jan 2011 11:12:04 +0000
Message-ID: <AANLkTimmLbtQUDWZGChH9LzwNwv6ZXihTz4a+mZefm60@mail.gmail.com>
Subject: Re: Kernel Panic wlc_mac80211.c Line 6093
To: Brett Rudley <brudley@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Someone here is suggesting that adding maxcpus=1 to the boot options
has fixed their crashes. Could this be my issue?

https://bbs.archlinux.org/viewtopic.php?pid=877645
