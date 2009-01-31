Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:39530 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbZAaCnJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 21:43:09 -0500
Message-ID: <4983BAB6.1020304@openwrt.org> (sfid-20090131_034316_147178_A186D017)
Date: Sat, 31 Jan 2009 03:43:02 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	me@bobcopeland.com
Subject: Re: [PATCH 1/5] ath5k: PHY code cleanup
References: <20090131022310.GA3342@makis>
In-Reply-To: <20090131022310.GA3342@makis>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nick Kossifidis wrote:
> * Clean up initial rf buffer settings (new file rfbufer.h) and
> introduce a new way to access specific rf registers (will use it
> later)
> 
> * Clean up initial rf gain settings by moving them on a new file
> (rfgain.h) so we can later work on gain optimization functions
> 
> * Update initial rf buffer settings and initial rf gain settings from
> HALs. This breaks things for now because our current dumps come from
> pre-configured rf buffer (regdumps already had the needed values set
> from binary HAL).
> 
> Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>
For the whole series:
Acked-by: Felix Fietkau <nbd@openwrt.org>

Nick: Do you want me to rebase my 2413 RF changes on top of
this series? Another thing: could you please test if my stuff also
works on RF2425? I don't have such a card.

Thanks,

- Felix
