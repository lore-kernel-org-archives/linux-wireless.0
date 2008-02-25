Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:57738 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYBYCXv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2008 21:23:51 -0500
Date: Sun, 24 Feb 2008 21:23:36 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com
Subject: Re: [ath5k-devel] [PATCH 6/8] ath5k: Fixes for PCI-E cards
Message-ID: <20080225022336.GA8936@hash.localnet> (sfid-20080225_022355_475845_ECED8E52)
References: <20080224042851.GE4426@makis.domain.invalid> <40f31dec0802232045v2902d76dg8ee1c4a4685862fe@mail.gmail.com> <20080224175933.GA4360@hash.localnet> <40f31dec0802241548g6ffb13f3x122046a184eeeac9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0802241548g6ffb13f3x122046a184eeeac9@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Some thoughts...
> 
> It seems we are doing calibration wrong, i'll check out the other
> chips as well to come up with something, until then can you check out
> how does your card perform on b rates (eg. 11Mbits). Do an iperf test

Hey, that's a good clue... I just switched over to b-only and it seems to
be much more stable.  It may be a few days before I can do the iperf tests,
gotta reconfigure my LAN somewhat.

-- 
Bob Copeland %% www.bobcopeland.com 

