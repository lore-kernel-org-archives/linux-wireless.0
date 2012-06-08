Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60216 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759228Ab2FHRvh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 13:51:37 -0400
Message-ID: <1339177894.5748.24.camel@jlt3.sipsolutions.net> (sfid-20120608_195141_847295_9D9CD38B)
Subject: Re: [PATCH] mac80211: print info when disabling HT
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 08 Jun 2012 19:51:34 +0200
In-Reply-To: <20120608173804.GB13889@tuxdriver.com>
References: <1338962733.4513.1.camel@jlt3.sipsolutions.net>
	 <20120608173804.GB13889@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-08 at 13:38 -0400, John W. Linville wrote:
> On Wed, Jun 06, 2012 at 08:05:33AM +0200, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > Make mac80211 print a message when it disables
> > HT due to the connection using WEP/TKIP or due
> > to the AP not supporting WMM/QoS.
> > 
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > ---
> > Did this slip through? :-)
> 
> I've got it on the wireless-next side.

Oops, must've missed it, sorry!

johannes

