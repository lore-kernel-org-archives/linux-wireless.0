Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:57613 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751740AbZGBLnZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2009 07:43:25 -0400
Date: Thu, 2 Jul 2009 14:43:16 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jmalinen@atheros.com>
Subject: Re: [PATCH 8/8 v3.1] mac80211: re-add HT disabling
Message-ID: <20090702114316.GA12652@jm.kir.nu>
References: <20090630115303.111250594@sipsolutions.net> <20090630132547.GB24667@vasanth-laptop> <1246369077.16643.10.camel@johannes.local> <20090630135207.GC24667@vasanth-laptop> <1246370452.16643.11.camel@johannes.local> <1246433956.16643.35.camel@johannes.local> <20090701101336.GD24667@vasanth-laptop> <1246444959.4131.15.camel@johannes.local> <20090702095134.GA11235@jm.kir.nu> <1246528397.16770.31.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1246528397.16770.31.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 02, 2009 at 11:53:17AM +0200, Johannes Berg wrote:

> So we have to support multiple for connect() to allow the card/driver to
> choose, but a single one for associate()?

Sounds reasonable.. Many drivers might not be able to handle multiple
options for connect(), though, so even with that, it may be reasonable
to just pass in a single option. Anyway, it would be nice if the
multiple options case could be supported.

-- 
Jouni Malinen                                            PGP id EFC895FA
