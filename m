Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:46097 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188Ab2LLOkg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 09:40:36 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Steev Klimaszewski <steev@genesi-usa.com>,
	Janusz Dziedzic <janusz.dziedzic@gmail.com>,
	Dmitry Tarnyagin <abi.dmitryt@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2 00/21] cw1200: ST-Ericsson cw1200 wlan device driver
References: <1330720003-15866-1-git-send-email-dmitry.tarnyagin@stericsson.com>
	<CAMG6FYjYMqf9C15Bid3hAfzTcB=gEXq8RWRcM9n+HNtvckgVZQ@mail.gmail.com>
	<CAFED-jk84vKMRr_NDThMqhZrnXt6ddhViztitB_=M_nKbC6c8Q@mail.gmail.com>
	<CA+Bgp3N2gUDoey-cXV+4sN0q+2Jm7+rPcu776FMUWxaR4F0qwg@mail.gmail.com>
	<20120706201839.GE1879@tuxdriver.com>
	<20121211232311.GA9080@shaftnet.org>
Date: Wed, 12 Dec 2012 16:40:32 +0200
In-Reply-To: <20121211232311.GA9080@shaftnet.org> (Solomon Peachy's message of
	"Tue, 11 Dec 2012 18:23:11 -0500")
Message-ID: <87sj7buye7.fsf@purkki.adurom.net> (sfid-20121212_154039_776061_BDA89D95)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Solomon Peachy <pizza@shaftnet.org> writes:

> I've been maintaining it on top of compat-wireless, and I'm wanting to 
> give it another upstream push, and be listed as the maintainer.  What's 
> the best way for me to do that?  The patch series they posted originally 
> (one file per patch) seems rather silly, but at the same time, doing it 
> all at once is a rather substantial chunk to digest/review.

With ath6kl I did so that for review I sent multiple patches (one file
per patch) but the final submission, after the review, was one huge
patch containing everything. I don't know if John still prefers that but
at least I would recommend to do so.

-- 
Kalle Valo
