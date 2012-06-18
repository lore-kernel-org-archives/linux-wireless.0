Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47536 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab2FRO7X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 10:59:23 -0400
Message-ID: <1340031558.4615.9.camel@jlt3.sipsolutions.net> (sfid-20120618_165926_544488_B5BDB034)
Subject: Re: [PATCH 0/7] nl/cfg/mac80211: add DFS master ability
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Date: Mon, 18 Jun 2012 16:59:18 +0200
In-Reply-To: <1340030798-28992-1-git-send-email-victorg@ti.com>
References: <1340030798-28992-1-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-06-18 at 17:46 +0300, Victor Goldenshtein wrote:
> In continuation to proposed RFC, this patch set (with hostap patch
> series) adds support for DFS (Dynamic Frequency Selection) according
> 802.11h.

Please fix coding style in this patchset first. There are various places
with bad indentation etc.

johannes

