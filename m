Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:46858 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458AbZK3D4e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Nov 2009 22:56:34 -0500
Subject: Re: [PATCH v2 2/2] iwmc3200wifi: rx aggregation support
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1259543481.12157.18.camel@debian>
References: <1259291917-1399-1-git-send-email-yi.zhu@intel.com>
	 <1259291917-1399-2-git-send-email-yi.zhu@intel.com>
	 <1259314800.5428.13.camel@johannes.local>
	 <1259543481.12157.18.camel@debian>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Nov 2009 11:56:39 +0800
Message-ID: <1259553399.12157.21.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-11-30 at 09:11 +0800, Zhu Yi wrote:
> > You did the right thing in mac80211, but not here -- if it returns
> an error it hasn't freed 'skb', only modified it.
> 
> Indeed. 

Speak too soon. I freed it in the calling function. But I'll still use
your suggestion to consume the skb here, for the reason I mentioned
early.

Thanks,
-yi

