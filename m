Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52098 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933523AbbIVNYz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 09:24:55 -0400
Message-ID: <1442928291.2018.8.camel@sipsolutions.net> (sfid-20150922_152501_654619_7844F8BC)
Subject: Re: [PATCH] mac80211: reset CQM history upon reconfiguration
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
	Sara Sharon <sara.sharon@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 22 Sep 2015 15:24:51 +0200
In-Reply-To: <1442839660-25790-1-git-send-email-luca@coelho.fi>
References: <1442839660-25790-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-09-21 at 15:47 +0300, Luca Coelho wrote:
> From: Sara Sharon <sara.sharon@intel.com>
> 
> Current behavior of notifying CQM events is inconsistent.
> Upon first configuration there is a cqm event of channel status
> according to threshold configured, regardless of signal stability.
> When there is reconfiguration no event is sent unless there is
> a significant change to the signal level according to the new
> configuration.
> 
> Since current reconfiguration behavior might cause missing CQM
> events in case current signal did not change but is crossing the
> new threshold, fix that by resetting latest signal level upon
> reconfiguration.
> 
Applied.

johannes
