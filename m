Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.243]:34761 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbYBJTFk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 14:05:40 -0500
Received: by an-out-0708.google.com with SMTP id d31so1071332and.103
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2008 11:05:38 -0800 (PST)
Message-ID: <40f31dec0802101105o61442683ia6b56c264a9af556@mail.gmail.com> (sfid-20080210_190548_423654_071B785C)
Date: Sun, 10 Feb 2008 21:05:38 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: ath5k: reset for 5424-based card
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20080210162155.GA10894@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080131155901.GA7997@hash.localnet>
	 <40f31dec0801310856p28513848nd22c4b3c590b7a46@mail.gmail.com>
	 <20080201040358.GA13428@hash.localnet>
	 <40f31dec0802010409i47374309o5da3d76fb1bc7025@mail.gmail.com>
	 <20080201225345.GA15922@hash.localnet>
	 <40f31dec0802011748i5a1b8aaftf42f7798762cca3d@mail.gmail.com>
	 <20080203014559.GA20177@hash.localnet>
	 <40f31dec0802050113w6f332a00ja7c9ad849f80e2e0@mail.gmail.com>
	 <20080210162155.GA10894@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/2/10, Bob Copeland <me@bobcopeland.com>:
> On Tue, Feb 05, 2008 at 11:13:35AM +0200, Nick Kossifidis wrote:
> > It's fine, that's cool it seems phy is ok (and hopefully is the same
> > with 5413 as i thought), it must be some mac settings related to pci-e
> > that result rx overrun, i've spotted some registers but i'll need to
> > spend some time on it and right now that's not possible ;-(
>
> So I played around with the code this weekend and have gotten it to
> work somewhat (I am posting this using the driver).  I think it only
> works right after system power-up and something's not right because it's
> a little laggy.
>
> One weird thing -- in my traces, the g-mode tables seem to be the b-mode
> tables and vice-versa.  I may have mixed up the trace files but I'm not
> sure how.  Anyway it works without changes to the initvals.
>
> I'll post a patch later tonight.
>

Did you forced b mode via iwpriv while tracing (even if ap is b-only
card will use g settings) ? You should at least see different IFS etc
settings (check out initvals).

Good work ;-)


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
