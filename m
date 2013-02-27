Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760001Ab3B0OyC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 09:54:02 -0500
Date: Wed, 27 Feb 2013 15:54:11 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: Re: [PATCH 2/6] mac80211: sync suspend and stop interface
Message-ID: <20130227145410.GA8202@redhat.com> (sfid-20130227_155407_486419_EB74D06B)
References: <1361793008-2857-1-git-send-email-sgruszka@redhat.com>
 <1361793008-2857-2-git-send-email-sgruszka@redhat.com>
 <1361911440.8440.12.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1361911440.8440.12.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 26, 2013 at 09:44:00PM +0100, Johannes Berg wrote:
> More generally, does this really make much sense? There are other things
> here, e.g. ieee80211_configure_filter(), ieee80211_recalc_ps(),
> ieee80211_hw_config() and probably more that can be executed in this
> function -- I don't think protecting these two calls is really
> sufficient?
> 
> I think it'd be smarter to delay the down until resumed, or so.

I'm thinking how to do this nicely. For now I'll skip this change
from my patch set.

Stanislaw
