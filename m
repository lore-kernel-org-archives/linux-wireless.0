Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:49595 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbYJFJdU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 05:33:20 -0400
Subject: Re: [PATCH] Working packet injection patch for ipw2200 - enables
	aireplay-ng and others to work
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Paul <paul14075@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1223284624.24551.91.camel@johannes.berg>
References: <7d553cf40809271345n3a945091u6c341e65c51811d5@mail.gmail.com>
	 <1222571710.2510.587.camel@debian.sh.intel.com>
	 <7d553cf40809280059v454023eaxc8a570fb6d4efcf@mail.gmail.com>
	 <7d553cf40809281228l13414507xc11e8e592493e43@mail.gmail.com>
	 <1223284316.2510.721.camel@debian.sh.intel.com>
	 (sfid-20081006_111343_274436_FA74EFEC)  <1223284624.24551.91.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 06 Oct 2008 17:31:37 +0800
Message-Id: <1223285497.2510.732.camel@debian.sh.intel.com> (sfid-20081006_113324_839314_49A09AD1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-10-06 at 03:17 -0600, Johannes Berg wrote:
> 
> how about making use of cfg80211 to create the monitor interface to
> start with?

Nice try. It is not a mac80211 based driver. I don't know how much
effort it takes. But it will be great if it works. Maybe we can also
replace ieee80211 with cfg80211 or lib80211 in the future? ;-)

Thanks,
-yi

