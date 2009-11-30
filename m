Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49452 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbZK3Cet (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Nov 2009 21:34:49 -0500
Subject: Re: [RFC 1/2] wireless: add ieee80211_asmdu_to_8023s
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1259314217.12157.3.camel@debian>
References: <1259215413-16753-1-git-send-email-yi.zhu@intel.com>
	 <1259229943.32372.50.camel@johannes.local>
	 <1259290376.13126.219.camel@debian>
	 <1259313653.5428.5.camel@johannes.local>  <1259314217.12157.3.camel@debian>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Nov 2009 10:34:54 +0800
Message-ID: <1259548494.12157.19.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-11-27 at 17:30 +0800, Zhu Yi wrote:
> > No, davem and I optimised that away a long time ago via using
> > netdev->needed_headroom and netdev->needed_tailroom. It even works
> for bridges and their slave devices, iirc. 
> 
> I missed this. Will check it. If so, I'll add another parameter to
> pass the extra hw tx headroom to ieee80211_asmdu_to_8023s. 

Now I see your changes to LL_RESERVED_SPACE*(). Thanks!

-yi

