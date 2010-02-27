Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1477 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936236Ab0B0VtO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 16:49:14 -0500
Date: Sat, 27 Feb 2010 16:48:53 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Andrew Blaich <ablaich@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Ath5k and Retransmissions (Retries)
Message-ID: <20100227214853.GA15557@hash.localnet>
References: <6b5e31691002250640k154a1f22xa46bac547c69b250@mail.gmail.com> <b6c5339f1002250951q7ad35de6g2a15f7c77e454b9a@mail.gmail.com> <6b5e31691002250959o576e203ena04858c8c9a76486@mail.gmail.com> <20100227004810.GB13107@hash.localnet> <6b5e31691002270939p5150af48r3bcbe1cfeec4691d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6b5e31691002270939p5150af48r3bcbe1cfeec4691d@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 27, 2010 at 12:39:51PM -0500, Andrew Blaich wrote:
> It should be noted that any card that uses the
> ath5k_hw_setup_4word_tx_desc function (e.g 5212 and like devices) has
> an additional 4 retries, AR5K_TUNE_HWTXTRIES, added to the value in
> tx_tries0 the sum of which , appears to be,  is written to the
> AR5K_4W_TX_DESC_CTL2_XMIT_TRIES0 register on the device.

Hrm, yeah that should probably go away.

-- 
Bob Copeland %% www.bobcopeland.com

