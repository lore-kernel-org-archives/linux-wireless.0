Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sidious.london.02.net ([82.132.130.152]:58666 "EHLO
	mail.o2.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754516Ab1CORQH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 13:16:07 -0400
Date: Tue, 15 Mar 2011 17:15:43 +0000
From: Tony Houghton <h@realh.co.uk>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Could ath9k and rt2800pci bugs be related?
Message-ID: <20110315171543.3723e07f@realh.co.uk>
In-Reply-To: <AANLkTinmD3aJphAcge0xunk4sS4pec20u3PSKTE0Og6=@mail.gmail.com>
References: <20110224182022.57e32862@toddler>
	<20110224200203.GB17412@elie>
	<20110314164812.4c0cfc29@toddler>
	<AANLkTimSZrGCzBaB9K=WVO7faGNM-+qeKEE2qzjkPnSD@mail.gmail.com>
	<20110315131907.6f06a221@toddler>
	<AANLkTi=Gub1JAO21qtRjxVWrtc6Masp1siF3NHntgcvp@mail.gmail.com>
	<20110315151746.421c04b3@toddler>
	<AANLkTinmD3aJphAcge0xunk4sS4pec20u3PSKTE0Og6=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 15 Mar 2011 21:47:14 +0530
Mohammed Shafi <shafi.wireless@gmail.com> wrote:

> i dont know what to say, may be you can look at
> vim /drivers/net/wireless/ath/ath9k/pci.c
> and
> vim /net/mac80211/pm.c
> let me also see if i can get the problem reproduced

When I installed wireless-compat it didn't replace all the modules it
provides, only the ones I'd activated with driver-select ath9k. I didn't
notice whether mac80211 drivers got replaced too. If I want to alter
pm.c do I need to add anything to the driver-select line to make sure my
altered version gets installed?
