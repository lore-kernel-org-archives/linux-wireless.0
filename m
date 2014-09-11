Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55956 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549AbaIKKTE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 06:19:04 -0400
Message-ID: <1410430741.22863.4.camel@jlt4.sipsolutions.net> (sfid-20140911_121908_811689_26ED4397)
Subject: Re: [PATCH] mac80211: add TDLS connection timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Liad Kaufman <liad.kaufman@intel.com>
Date: Thu, 11 Sep 2014 12:19:01 +0200
In-Reply-To: <1409808520-905-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1409808520-905-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-09-04 at 08:28 +0300, Emmanuel Grumbach wrote:
> From: Liad Kaufman <liad.kaufman@intel.com>
> 
> Adding a timeout for tearing down a TDLS connection that
> hasn't had ACKed traffic sent through it for a certain
> amount of time.
> 
> Since we have no other monitoring facility to indicate the
> existance (or non-existance) of a peer, this patch will
> cause a peer to be considered as unavailable if for some X
> time at least some Y packets have all not been ACKed.

Applied.

johannes

