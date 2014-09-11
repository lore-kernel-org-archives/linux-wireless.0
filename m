Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55988 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325AbaIKKZk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 06:25:40 -0400
Message-ID: <1410431137.22863.9.camel@jlt4.sipsolutions.net> (sfid-20140911_122545_700413_1D41D167)
Subject: Re: [PATCH] mac80211: set network header in TDLS frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>
Date: Thu, 11 Sep 2014 12:25:37 +0200
In-Reply-To: <1410271862-10208-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1410271862-10208-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-09-09 at 17:11 +0300, Emmanuel Grumbach wrote:
> From: Arik Nemtsov <arik@wizery.com>
> 
> Correctly mark the network header location in mac80211-generated TDLS
> frames. These may be used by lower-level drivers.

Applied.

johannes

