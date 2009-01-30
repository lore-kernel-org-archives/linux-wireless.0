Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:1298 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbZA3Njc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 08:39:32 -0500
Date: Fri, 30 Jan 2009 08:39:21 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [PATCH,RFC 0/2] ath5k: implement tx power calibration on ar2413/5413
Message-ID: <20090130133921.GA14375@hash.localnet> (sfid-20090130_143936_223995_F1355E49)
References: <498269D5.7080204@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <498269D5.7080204@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 30, 2009 at 03:45:41AM +0100, Felix Fietkau wrote:
> Hi,
> 
> I got my AR2413 patches to the point where ath5k properly
> initializes the PDGAIN curves (register dumps verified against
> what the madwifi HAL does), and it does Tx at much better
> power level and with 54 Mbit (tested on an AR5413 card).
> Power still isn't as good as on madwifi yet, but much closer
> than before, and I actually get >20Mbit/s throughput now.

Very cool!  I didn't notice huge change in my environment with
a few iperf runs, however it is at least as good as before 
(around 14 Mbit/s for tcp).  And it looks like you fixed all 
the warnings, so that is good :)

-- 
Bob Copeland %% www.bobcopeland.com

