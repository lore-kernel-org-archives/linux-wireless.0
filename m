Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:46214 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbYBJQXG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 11:23:06 -0500
Date: Sun, 10 Feb 2008 11:21:55 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: ath5k: reset for 5424-based card
Message-ID: <20080210162155.GA10894@hash.localnet> (sfid-20080210_162320_011184_1574347D)
References: <20080131155901.GA7997@hash.localnet> <40f31dec0801310856p28513848nd22c4b3c590b7a46@mail.gmail.com> <20080201040358.GA13428@hash.localnet> <40f31dec0802010409i47374309o5da3d76fb1bc7025@mail.gmail.com> <20080201225345.GA15922@hash.localnet> <40f31dec0802011748i5a1b8aaftf42f7798762cca3d@mail.gmail.com> <20080203014559.GA20177@hash.localnet> <40f31dec0802050113w6f332a00ja7c9ad849f80e2e0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0802050113w6f332a00ja7c9ad849f80e2e0@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 05, 2008 at 11:13:35AM +0200, Nick Kossifidis wrote:
> It's fine, that's cool it seems phy is ok (and hopefully is the same
> with 5413 as i thought), it must be some mac settings related to pci-e
> that result rx overrun, i've spotted some registers but i'll need to
> spend some time on it and right now that's not possible ;-(

So I played around with the code this weekend and have gotten it to
work somewhat (I am posting this using the driver).  I think it only
works right after system power-up and something's not right because it's 
a little laggy.

One weird thing -- in my traces, the g-mode tables seem to be the b-mode 
tables and vice-versa.  I may have mixed up the trace files but I'm not
sure how.  Anyway it works without changes to the initvals.

I'll post a patch later tonight.

-- 
Bob Copeland %% www.bobcopeland.com 

