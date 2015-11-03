Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55424 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbbKCJav (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 04:30:51 -0500
Message-ID: <1446543047.29010.4.camel@sipsolutions.net> (sfid-20151103_103233_106206_1B7E0AD6)
Subject: Re: [PATCH 09/10] mac80211: allow null chandef in tracing
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>
Date: Tue, 03 Nov 2015 10:30:47 +0100
In-Reply-To: <1445763582-11421-9-git-send-email-emmanuel.grumbach@intel.com>
References: <1445763582-11421-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1445763582-11421-9-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-10-25 at 10:59 +0200, Emmanuel Grumbach wrote:
> From: Arik Nemtsov <arik@wizery.com>
> 
> In TDLS channel-switch operations the chandef can sometimes be NULL.
> Avoid an oops in the trace code for these cases and just print a
> chandef full of zeros.
> 
Applied, thanks.

johannes
