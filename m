Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:3686 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbZAaWiZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jan 2009 17:38:25 -0500
Date: Sat, 31 Jan 2009 17:38:09 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	nbd@openwrt.org
Subject: Re: [ath5k-devel] [PATCH 5/5] ath5k: Update reset code
Message-ID: <20090131223809.GA17413@hash.localnet> (sfid-20090131_233829_341825_681A8B76)
References: <20090131023147.GE3342@makis> <20090131170802.GA16826@hash.localnet> <40f31dec0901311048t3834612cgc6b1dd01aa42a5c0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0901311048t3834612cgc6b1dd01aa42a5c0@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 31, 2009 at 08:48:02PM +0200, Nick Kossifidis wrote:
> > Heh, we should write a little tool to check the shifts and masks :)
> >
> 
> Yup :P

I just wrote one, I can post it later :)   It also found:

AR5K_PHY_SIGMA_DELTA_ADC_CLIP 0x01ff3000 13

Should be 12 or a different mask...

> Thanks a lot for your comments, i'll address them asap and come up
> with a new version of this patch ;-)

My computer also hangs with the whole series... reverting the reset
part makes it work.  I'll try and narrow that down later when I 
get some time.

-- 
Bob Copeland %% www.bobcopeland.com

