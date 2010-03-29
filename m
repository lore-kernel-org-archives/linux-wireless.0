Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017Ab0C2OGh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 10:06:37 -0400
Date: Mon, 29 Mar 2010 14:08:33 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>, wey-yi.w.guy@intel.com
Subject: Re: [PATCH v2 3/3] mac80211: enable QoS explicitly in AP mode
Message-ID: <20100329120832.GA2593@dhcp-lab-161.englab.brq.redhat.com>
References: <1269857916-4440-1-git-send-email-sgruszka@redhat.com> <1269857916-4440-2-git-send-email-sgruszka@redhat.com> <1269857916-4440-3-git-send-email-sgruszka@redhat.com> <1269868568.4131.31.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1269868568.4131.31.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 29, 2010 at 03:16:08PM +0200, Johannes Berg wrote:
> On Mon, 2010-03-29 at 12:18 +0200, Stanislaw Gruszka wrote:
> > Enable QoS explicitly, when user space AP program will setup a QoS
> > queues. Currently this is not needed as iwlwifi not work in AP mode
> > and no other driver implement enable/disable QoS.
> 
> Shouldn't this be part of patch 1?

This part is not really needed to make anything works. Moreover
can break things. Even it is untested. So I did it separately.

> Does IBSS/mesh support QoS?

It is described in specification, at least for IBSS.
Does we support it - no.

Stanislaw
