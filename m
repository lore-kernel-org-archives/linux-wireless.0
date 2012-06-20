Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:38498 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755832Ab2FTKeb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 06:34:31 -0400
Message-ID: <4FE1A734.4090100@neratec.com> (sfid-20120620_123435_338183_A82492F7)
Date: Wed, 20 Jun 2012 12:34:28 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Victor Goldenshtein <victorg@ti.com>
CC: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, adrian.chadd@gmail.com, j@w1.fi,
	johannes@sipsolutions.net, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Subject: Re: [PATCH 0/7] nl/cfg/mac80211: add DFS master ability
References: <1340030798-28992-1-git-send-email-victorg@ti.com>
In-Reply-To: <1340030798-28992-1-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/18/2012 04:46 PM, Victor Goldenshtein wrote:
> In continuation to proposed RFC, this patch set (with hostap patch series) adds support for DFS (Dynamic Frequency Selection) according 802.11h.
> 
> [...]

Thanks for the updated patches, Victor.

Going to test them by preparing the ath9k interface.

Right now they do not apply on top of wireless-testing, could you please
rebase? Thanks.
