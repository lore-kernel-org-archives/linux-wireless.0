Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40067 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843Ab1KOOpd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Nov 2011 09:45:33 -0500
Date: Tue, 15 Nov 2011 09:37:56 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	rodrigue@qca.qualcomm.com, shafi.wireless@gmail.com,
	nbd@openwrt.org
Subject: Re: [PATCH 0/2] ath9k: DFS radar detection
Message-ID: <20111115143755.GB2483@tuxdriver.com> (sfid-20111115_154536_664229_844D87F4)
References: <1320770044-12271-1-git-send-email-zefir.kurtisi@neratec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1320770044-12271-1-git-send-email-zefir.kurtisi@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 08, 2011 at 05:34:02PM +0100, Zefir Kurtisi wrote:
> This patch series proposes DFS radar pulse detection for ath9k.
> 
> The first patch adds a new DFS module, the second turns those
> knobs to enable the HW to detect radar pulses and forward them
> to the new module.
> 
> Here, sanity and plausibility checks that are HW dependent are
> performed and resulting radar events are passed to higher level
> generic pattern detectors for further processing (spectrum
> management, etc.).
> 
> DFS support is limited to newer chip-sets (for now 9280 and later).
> 
> So far, AP operation on DFS channels is not supported by 
> mac80211/hostapd. Testing the proposed pulse detection is done in
> monitor mode.
> 
> Zefir Kurtisi (2):
>   ath9k: add DFS radar pulse processing
>   ath9k: integrate initial DFS module

Any comments from the ath9k guys on this?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
