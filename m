Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53667 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab2IGR1s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 13:27:48 -0400
Message-ID: <1347038903.4256.38.camel@jlt4.sipsolutions.net> (sfid-20120907_192751_495173_1AB6ECFA)
Subject: Re: [PATCH v2] p54: connect to 11w protected networks
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Date: Fri, 07 Sep 2012 19:28:23 +0200
In-Reply-To: <1347037745.4256.37.camel@jlt4.sipsolutions.net> (sfid-20120907_190840_355951_AEB493EB)
References: <1346622538.10113.3.camel@jlt4.sipsolutions.net>
	 <201209071825.13588.chunkeey@googlemail.com>
	 <1347035277.4256.33.camel@jlt4.sipsolutions.net>
	 <201209071901.59705.chunkeey@googlemail.com>
	 (sfid-20120907_190207_971998_7DE5E0BF) <1347037745.4256.37.camel@jlt4.sipsolutions.net>
	 (sfid-20120907_190840_355951_AEB493EB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-09-07 at 19:09 +0200, Johannes Berg wrote:
> On Fri, 2012-09-07 at 19:01 +0200, Christian Lamparter wrote:
> 
> > > > Oh no, I mean dynamic reconfiguration of the firmware's
> > > > keycache during runtime. 
> > > 
> > > Right right, but for MFP that doesn't help since in AP mode
> > > we don't know whether to expect encrypted management frames
> > > or not.
> > 
> > Hmpf, don't we set the CMAC key in this case? 
> 
> Hmm, I guess we would have that, and actually ... we know MFP will be
> used for the *station* so we should in fact know this already. I'll need
> to revise my patch. D'oh.

I just posted a new patch. I haven't really tested it though, but I'm
pretty sure it'll work.

johannes

