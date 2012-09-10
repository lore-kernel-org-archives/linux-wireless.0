Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35968 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab2IJLZZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 07:25:25 -0400
Message-ID: <1347276361.4272.20.camel@jlt4.sipsolutions.net> (sfid-20120910_132528_107037_9DE75773)
Subject: Re: [PATCH v3 7/7] mac80211: add DFS support to monitor interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Date: Mon, 10 Sep 2012 13:26:01 +0200
In-Reply-To: <1344426823-1795-8-git-send-email-victorg@ti.com>
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
	 <1344426823-1795-8-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-08-08 at 14:53 +0300, Victor Goldenshtein wrote:
> AP mode uses monitor interfaces to transmit
> management frames which were blocked for "radar
> channels" until now.
> 
> Stop dropping packets if we are on 'radar channel'
> and the DFS is enabled.

Umm, no? Check for dfs_en_tx().

johannes

