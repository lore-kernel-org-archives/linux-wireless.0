Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:61686 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761535Ab3EBUP6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 16:15:58 -0400
Received: by mail-we0-f174.google.com with SMTP id z2so800463wey.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 May 2013 13:15:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5182A9DC.6030203@openwrt.org>
References: <1367482308-9882-1-git-send-email-linux@rempel-privat.de>
	<1367482308-9882-2-git-send-email-linux@rempel-privat.de>
	<CAJ-Vmo=rZrHmXD0Os-Mb40jSEywbO-7GHSqL=7iMbkzAfS=+UQ@mail.gmail.com>
	<5182A341.8050704@rempel-privat.de>
	<5182A9DC.6030203@openwrt.org>
Date: Thu, 2 May 2013 13:15:57 -0700
Message-ID: <CAJ-Vmo=XYK=Jkc40U_vJO03n+tiA_LDpw8e1QKYRX6-+E9o4fA@mail.gmail.com> (sfid-20130502_221604_217757_BFBD0064)
Subject: Re: [ath9k-devel] [PATCH 1/2] ath9k_htc: add STBC TX support
From: Adrian Chadd <adrian@freebsd.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Well, let's dig into the firmware a bit more and tidy up how STBC is handled.



Adrian
