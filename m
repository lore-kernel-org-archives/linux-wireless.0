Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53065 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2KPMhD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 07:37:03 -0500
Message-ID: <1353069457.9490.3.camel@jlt4.sipsolutions.net> (sfid-20121116_133714_359018_B7E75A4C)
Subject: Re: [RFC v2 4/8] nl80211/cfg80211: support VHT channel configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 16 Nov 2012 13:37:37 +0100
In-Reply-To: <50A62FDA.2070307@posedge.com>
References: <1352492254-29399-1-git-send-email-johannes@sipsolutions.net>
	 <1352492254-29399-5-git-send-email-johannes@sipsolutions.net>
	 <50A62FDA.2070307@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-16 at 17:51 +0530, Mahesh Palivela wrote:
> On 11/10/2012 01:47 AM, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> 
> > + *
> > + * @NL80211_CHAN_WIDTH_20_NOHT: 20 MHz, non-HT channel
> 
> Should we have NL80211_CHAN_WIDTH_LEGACY or rename 
> NL80211_CHAN_WIDTH_20_NOHT to NL80211_CHAN_WIDTH_NOHT to cover non HT 
> associations in both 2.4 & 5 GHz bands.

Huh? I must be misunderstanding something -- both 2.4 and 5 GHz bands
use 20 MHz bandwidth by default?

johannes

