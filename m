Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12986 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbZEUHR2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 03:17:28 -0400
Subject: Re: [PATCH 1/2] wireless: move some utility functions from
 mac80211 to cfg80211
From: Zhu Yi <yi.zhu@intel.com>
To: drago01 <drago01@gmail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Ortiz, Samuel" <samuel.ortiz@intel.com>
In-Reply-To: <f6ca9fed0905210012t2b494db5w3169ef2e8db2b04b@mail.gmail.com>
References: <1242872340-27417-1-git-send-email-yi.zhu@intel.com>
	 <1242872340-27417-2-git-send-email-yi.zhu@intel.com>
	 <f6ca9fed0905210012t2b494db5w3169ef2e8db2b04b@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 21 May 2009 15:09:41 +0800
Message-Id: <1242889781.24825.611.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-05-21 at 15:12 +0800, drago01 wrote:
> On Thu, May 21, 2009 at 4:18 AM, Zhu Yi <yi.zhu@intel.com> wrote:
> > The patch moves some utility functions from mac80211 to cfg80211.
> > Because these functions are doing generic 802.11 operations so they
> > are not mac80211 specific. The moving allows some fullmac drivers
> > to be also benefit from these utility functions.
> 
> Isn't lib80211 a better place for those ?
> Its purpose is sharing code between fullmac and softmac drivers.

These functions are moved from mac80211 which currently doesn't link
with lib80211. Johannes might have more to comment.

Thanks,
-yi

