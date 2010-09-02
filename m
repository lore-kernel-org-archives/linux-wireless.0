Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909Ab0IBLKz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Sep 2010 07:10:55 -0400
Date: Thu, 2 Sep 2010 13:07:18 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH w-t] iwlwifi: rewrite iwl-scan.c to avoid race conditions
Message-ID: <20100902110717.GC2372@redhat.com>
References: <20100831150021.GA10963@redhat.com>
 <1283420177.3793.97.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1283420177.3793.97.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 02, 2010 at 11:36:17AM +0200, Johannes Berg wrote:
> On Tue, 2010-08-31 at 17:00 +0200, Stanislaw Gruszka wrote:
> 
> > +	priv->status &= IWL_PRESERVE_STATUS_MASK;
> 
> Is that completely save here? No other functions can interfere?

I don't know, I think is not safe, but seems that is not worse 
compeered to what we have now.

> I just ported your patch to the current tree:
> http://johannes.sipsolutions.net/patches/kernel/all/LATEST/NNN-iwl-scan.patch
> 
> but I'm going to split it up into multiple now.

Ok, if you want to. I could to this as well, actually I should
doing that way from the beginning.

Stanislaw
