Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:52113 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751558Ab0JDWsM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 18:48:12 -0400
Date: Tue, 5 Oct 2010 01:47:54 +0300
From: Jouni Malinen <j@w1.fi>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <Amod.Bodas@atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>
Subject: Re: [PATCH v2 0/3] mac80211: fix rate_control_send_low warnings
 for delbas
Message-ID: <20101004224754.GA16357@jm.kir.nu>
References: <1285965233-11097-1-git-send-email-lrodriguez@atheros.com>
 <1286198845.3620.37.camel@jlt3.sipsolutions.net>
 <20101004164149.GE2105@tux>
 <1286210566.3620.42.camel@jlt3.sipsolutions.net>
 <20101004172504.GL2105@tux>
 <1286213426.3620.43.camel@jlt3.sipsolutions.net>
 <20101004173507.GN2105@tux>
 <20101004203900.GA14524@jm.kir.nu>
 <AANLkTinwwvsLzovff4DKTktWuD6UdbRiEAs3g6jj-94Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTinwwvsLzovff4DKTktWuD6UdbRiEAs3g6jj-94Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 04, 2010 at 02:07:22PM -0700, Luis R. Rodriguez wrote:
> Jouni, just to be clear so you are fine with dropping explicitly the
> tear down of the BA agreement to the old AP?

If you are talking about not transmitting a frame, then yes, but
obviously, we would still need to locally tear down whatever we have set
up..

I think it would be a good default policy to not send any frames to the
old AP after we have decided to roam to a new one. If this does not work
well in some networks, I would like to here more detailed description on
what exactly is happening.

-- 
Jouni Malinen                                            PGP id EFC895FA
