Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:49193 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753892AbXFXKvP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jun 2007 06:51:15 -0400
Date: Sun, 24 Jun 2007 12:51:13 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: andy@warmcat.com, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH Try#14 1/4] mac80211: Monitor mode radiotap injection  docs
Message-ID: <20070624125113.551ad748@logostar.upir.cz>
In-Reply-To: <1182677792.21939.130.camel@johannes.berg>
References: <20070624085757.244871712@warmcat.com>
	<20070624090144.845936552@warmcat.com>
	<1182677792.21939.130.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 24 Jun 2007 11:36:32 +0200, Johannes Berg wrote:
> On Sun, 2007-06-24 at 09:57 +0100, andy@warmcat.com wrote:
> > plain text document attachment (mac80211-docs-radiotap-usage.patch)
> > Try #14
> >  - Documented Jiri Benc's injection encapsulation method

Hm, replied to the other (kill mgmt interface) thread without looking
through other mails :-(

> I still don't see the point since we've previously established that it
> won't help on other interfaces (qdiscs, ...); for monitor interfaces #13
> is enough and much simpler.
> 
> I'd vote for applying #13.

Agreed.

 Jiri

-- 
Jiri Benc
SUSE Labs
