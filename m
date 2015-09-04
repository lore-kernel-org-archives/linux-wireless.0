Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48526 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbbIDMc1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Sep 2015 08:32:27 -0400
Message-ID: <1441369944.1971.5.camel@sipsolutions.net> (sfid-20150904_143230_248044_78BE347D)
Subject: Re: [PATCH 8/9] mac80211: avoid VHT usage with no 80MHz chans
 allowed
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>
Date: Fri, 04 Sep 2015 14:32:24 +0200
In-Reply-To: <1439667594-13632-9-git-send-email-emmanuel.grumbach@intel.com>
References: <1439667594-13632-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1439667594-13632-9-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-08-15 at 22:39 +0300, Emmanuel Grumbach wrote:
> From: Arik Nemtsov <arik@wizery.com>
> 
> Currently if 80MHz channels are not allowed for use, the VHT IE is 
> not
> included in the probe request for an AP. This is not good enough if 
> the
> AP is configured with the wrong regulatory and supports VHT even 
> where
> prohibited or in TDLS scenarios.
> Mark the ifmgd with the DISABLE_VHT flag for the misbehaving-AP case, 
> and
> unset VHT support from the peer-station entry for the TDLS case.
> 
Applied.

johannes
