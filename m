Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50517 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab0JDQms (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 12:42:48 -0400
Subject: Re: [PATCH v2 0/3] mac80211: fix rate_control_send_low warnings
 for delbas
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>, Jouni Malinen <j@w1.fi>,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <Amod.Bodas@Atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
In-Reply-To: <20101004164149.GE2105@tux>
References: <1285965233-11097-1-git-send-email-lrodriguez@atheros.com>
	 <1286198845.3620.37.camel@jlt3.sipsolutions.net>
	 <20101004164149.GE2105@tux>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 18:42:46 +0200
Message-ID: <1286210566.3620.42.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-04 at 09:41 -0700, Luis R. Rodriguez wrote:
> On Mon, Oct 04, 2010 at 06:27:25AM -0700, Johannes Berg wrote:
> > How about this instead of your patches 2 and 3?
> > 
> > We're disassociating from the old AP since we associate with the new AP,
> > so there's not a whole lot of sense in explicitly tearing down
> > aggregation sessions either, right?
> 
> Good question, but why do we not get a warning when transmitting
> the disassoc frame?

We aren't transmitting a disassoc frame!

johannes

