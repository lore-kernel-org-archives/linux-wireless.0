Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3297 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172AbZKVDUK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Nov 2009 22:20:10 -0500
Date: Sat, 21 Nov 2009 22:18:46 -0500
From: Bob Copeland <me@bobcopeland.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ath5k-devel@lists.ath5k.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	pm list <linux-pm@lists.linux-foundation.org>,
	netdev@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [Resend][PATCH] Wireless / ath5k: Simplify suspend and resume
	callbacks
Message-ID: <20091122031846.GA6215@hash.localnet>
References: <200911212344.24170.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200911212344.24170.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 21, 2009 at 11:44:24PM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: Wireless / ath5k: Simplify suspend and resume callbacks
> 
> Simplify the suspend and resume callbacks of ath5k by converting the
> driver to struct dev_pm_ops and allowing the PCI PM core to do the
> PCI-specific suspend/resume handling.
> 
> Tested with Atheros Communications Inc. AR2413 802.11bg NIC (rev 01)
> D-Link CardBus.adapter.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Bob Copeland <me@bobcopeland.com>

Thanks for the resend, sorry it got lost in the shuffle.

-- 
Bob Copeland %% www.bobcopeland.com

