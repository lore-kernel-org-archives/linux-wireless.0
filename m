Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39319 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab0C2OXi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 10:23:38 -0400
Subject: Re: [PATCH v2 3/3] mac80211: enable QoS explicitly in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>, wey-yi.w.guy@intel.com
In-Reply-To: <20100329122425.GB2593@dhcp-lab-161.englab.brq.redhat.com>
References: <1269857916-4440-1-git-send-email-sgruszka@redhat.com>
	 <1269857916-4440-2-git-send-email-sgruszka@redhat.com>
	 <1269857916-4440-3-git-send-email-sgruszka@redhat.com>
	 <1269868568.4131.31.camel@jlt3.sipsolutions.net>
	 <20100329120832.GA2593@dhcp-lab-161.englab.brq.redhat.com>
	 <1269871956.4131.39.camel@jlt3.sipsolutions.net>
	 <20100329122425.GB2593@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 16:23:31 +0200
Message-ID: <1269872611.4131.40.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-03-29 at 14:24 +0200, Stanislaw Gruszka wrote:
> On Mon, Mar 29, 2010 at 04:12:36PM +0200, Johannes Berg wrote:
> > > > Shouldn't this be part of patch 1?
> > > 
> > > This part is not really needed to make anything works. Moreover
> > > can break things. Even it is untested. So I did it separately.
> > 
> > But without it QoS-AP breaks.
> 
> Other drivers than iwlwifi, not implement IEEE80211_CONF_QOS so patch
> does no change for them - queues are initialized as it was before.
>    
> Only think that can break without patch is AP for iwlwifi, but AP
> not work for iwlwifi anyway, no?

Good point.

johannes

