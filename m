Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:39928 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755830Ab3JQCMP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Oct 2013 22:12:15 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21087.18050.72635.617321@gargle.gargle.HOWL> (sfid-20131017_041224_238420_1CAB1A54)
Date: Thu, 17 Oct 2013 07:38:02 +0530
To: Bruno Randolf <br1@einfach.org>
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org,
	Ingo Randolf <ingo.randolf@qupik.com>
Subject: Re: ath9k AR9287 status?
In-Reply-To: <524DA3DC.6060806@einfach.org>
References: <52492FB0.3010201@einfach.org>
	<5249443E.3080700@rempel-privat.de>
	<524954BE.8060603@einfach.org>
	<52497C2E.1060406@rempel-privat.de>
	<5249A2F7.5090908@einfach.org>
	<524DA3DC.6060806@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bruno Randolf wrote:
> I just tried current wireless-testing (3.12.0-rc3-wl) and it shows the 
> same problems.
> 
> For reference:
> 
> Card:  Unex DNXA-97 (AR9287) http://unex.com.tw/product/dnxa-97
> Board: Advantech MIO-2261N (Atom N260)
> 
> ASPM is disabled in the BIOS and by pcie_aspm=off. Scanning seems to 
> work, but when I start up hostapd (v2.0, simple AP config) nothing 
> happens (no AP is found by clients). When I stop hostapd the system 
> freezes with "BUG: soft lockup - CPU#3 stuck for 23s! (hostapd:2250)"

Can you post the kernel log with latest wireless-testing ?
Please load the driver with debug=0x8f49.

Sujith
