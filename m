Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466Ab0C2OWa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 10:22:30 -0400
Date: Mon, 29 Mar 2010 14:24:25 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>, wey-yi.w.guy@intel.com
Subject: Re: [PATCH v2 3/3] mac80211: enable QoS explicitly in AP mode
Message-ID: <20100329122425.GB2593@dhcp-lab-161.englab.brq.redhat.com>
References: <1269857916-4440-1-git-send-email-sgruszka@redhat.com> <1269857916-4440-2-git-send-email-sgruszka@redhat.com> <1269857916-4440-3-git-send-email-sgruszka@redhat.com> <1269868568.4131.31.camel@jlt3.sipsolutions.net> <20100329120832.GA2593@dhcp-lab-161.englab.brq.redhat.com> <1269871956.4131.39.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1269871956.4131.39.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 29, 2010 at 04:12:36PM +0200, Johannes Berg wrote:
> > > Shouldn't this be part of patch 1?
> > 
> > This part is not really needed to make anything works. Moreover
> > can break things. Even it is untested. So I did it separately.
> 
> But without it QoS-AP breaks.

Other drivers than iwlwifi, not implement IEEE80211_CONF_QOS so patch
does no change for them - queues are initialized as it was before.
   
Only think that can break without patch is AP for iwlwifi, but AP
not work for iwlwifi anyway, no?

Stanislaw
