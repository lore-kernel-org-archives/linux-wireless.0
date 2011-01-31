Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755468Ab1AaLdb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 06:33:31 -0500
Date: Mon, 31 Jan 2011 12:33:24 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org, bruno randolf <br1@einfach.org>
Subject: Re: [BUG] iwlwifi need to correct channels info
Message-ID: <20110131113323.GB22367@redhat.com>
References: <20110128154100.GB2452@redhat.com>
 <1296237969.5118.12.camel@jlt3.sipsolutions.net>
 <20110131093840.GA20613@redhat.com>
 <1296471188.3812.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1296471188.3812.0.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 31, 2011 at 11:53:08AM +0100, Johannes Berg wrote:
> > I tested on 3945, it fix freq=0 on messages. But what about something
> > slightly different? Use ch->band already set in iwl_init_channel_map()
> > and initialize sband->band.
> 
> Sure, looks fine too.

I'll remove sband->band assignments since cfg80211 initialize this
and post it.

Stanislaw
