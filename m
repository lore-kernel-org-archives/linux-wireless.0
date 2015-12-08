Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37804 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964951AbbLHPDZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2015 10:03:25 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	nbd@openwrt.org
Subject: Re: [PATCH v2 01/13] ath9k: add debug messages to aggr/chanctx funcs
References: <1448613438-5173-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Tue, 08 Dec 2015 17:03:16 +0200
In-Reply-To: <1448613438-5173-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Fri, 27 Nov 2015 09:37:06 +0100")
Message-ID: <874mft9e4r.fsf@kamboji.qca.qualcomm.com> (sfid-20151208_160331_029053_BD1A9427)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Add/extend debug messages when chanctx used.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Manually applied these patches to ath.git:

05a85a6c42b5 ath9k: remove ath9k_mod_tsf64_tu
02edab5b5f82 ath9k: MCC, print time elapsed between events
a64d876ef7dc ath9k: MCC, add NOA also in case of an AP
b10b7fb31a21 ath9k: P2P_CLIENT, get/set NOA correctly
3edbf0ba0494 ath9k: MCC enable Opportunistic Power Save
c1b7bea038f0 ath9k: setup correct skb priority for nullfunc
631c45f41957 ath9k: use u32 when calculate tsf
b77b59ae8acd ath9k: P2P_CLIENT, send frames after 1ms AP/GO will aprear
60337ed86306 ath9k: queue null frames in case of MCC
2f985539b98b ath9k: print real timer value
58bb9ca84c20 ath9k: add debug messages to aggr/chanctx funcs

These patches are still pending:

[v2,09/13] ath9k: request NOA update when chanctx active
[v2,11/13] ath9k: MCC add sta_ap_ratio module param

-- 
Kalle Valo
