Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:47613 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752579Ab0LFEpH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Dec 2010 23:45:07 -0500
Date: Sun, 5 Dec 2010 20:44:57 -0800
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] cfg80211: Add new BSS attribute ht_opmode
Message-ID: <20101206044457.GA13210@jm.kir.nu>
References: <1290166826-27063-1-git-send-email-helmut.schaa@googlemail.com>
 <1290583289.3790.4.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1290583289.3790.4.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 24, 2010 at 08:21:29AM +0100, Johannes Berg wrote:
> On Fri, 2010-11-19 at 12:40 +0100, Helmut Schaa wrote:
> > Not sure if we also want to pass in some other parts of the HT Operation
> > IE or maybe the whole IE?
> > 
> > At the moment the HT opmode is sufficient but in the future we might
> > want to support STBC beaconing and so on. Passing the whole IE would
> > not require any new interfaces later but also makes the interface less
> > nice IMO :)

> This seems fine to me. Any opinion from Jouni?

No strong preference either way, so it looks fine to go ahead with this
and add new attributes whenever something else is needed.

-- 
Jouni Malinen                                            PGP id EFC895FA
