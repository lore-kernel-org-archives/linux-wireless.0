Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56791 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab0HHS3t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Aug 2010 14:29:49 -0400
Received: by iwn33 with SMTP id 33so3078809iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Aug 2010 11:29:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTim4ccC7pQrW0LymdZ_cAiaBhLW3VofsFj9CcpfP@mail.gmail.com>
References: <AANLkTim4ccC7pQrW0LymdZ_cAiaBhLW3VofsFj9CcpfP@mail.gmail.com>
Date: Sun, 8 Aug 2010 20:29:49 +0200
Message-ID: <AANLkTi=o6m9pSaXQ4ago6sRoE1R7-O6uv0S35Dy2VO7a@mail.gmail.com>
Subject: Re: ath9k: association lost on ap side only
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/8/7 Björn Smedman <bjorn.smedman@venatech.se>:
> Hi all,
>
> I'm trying out compat-wireless-2010-07-29 with openwrt/trunk@22474
> patches on AR913x and quite often (a few times a day) run into a
> problem where my laptop thinks it's associated but the router thinks
> it's not.

I also run into some weirdness where the laptop disassociates (macos
reports it as "AirPort: Link Down on en1. Reason 4 (Disassociated due
to inactivity)"). From end-users point of view it's like if somebody
pulled the power on the router, but it comes back faster than it would
in that case.

The log looks like this when that happened:

Aug  8 18:20:11 OpenWrt user.debug kernel: ath: Timeout while waiting
for nf to load: AR_PHY_AGC_CONTROL=0x40d22
Aug  8 18:20:32 OpenWrt user.debug kernel: ath: DMA failed to stop in
10 ms AR_CR=0x00000024 AR_DIAG_SW=0x40000020
Aug  8 18:20:32 OpenWrt user.debug kernel: ath: DMA failed to stop in
10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
Aug  8 18:20:48 OpenWrt user.debug kernel: ath: DMA failed to stop in
10 ms AR_CR=0x00000024 AR_DIAG_SW=0x40000020
Aug  8 18:20:48 OpenWrt user.debug kernel: ath: DMA failed to stop in
10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020

/Björn
