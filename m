Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024Ab1DFM6W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 08:58:22 -0400
Date: Wed, 6 Apr 2011 14:57:29 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Cong Wang <amwang@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [Patch] iwlwifi: remove obsoleted module alias and parameters
Message-ID: <20110406125728.GA2197@redhat.com>
References: <1302083382-6715-1-git-send-email-amwang@redhat.com>
 <1302084582.3811.9.camel@jlt3.sipsolutions.net>
 <4D9C43A8.5060500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4D9C43A8.5060500@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 06, 2011 at 06:42:48PM +0800, Cong Wang wrote:
> 于 2011年04月06日 18:09, Johannes Berg 写道:
> >On Wed, 2011-04-06 at 17:49 +0800, Amerigo Wang wrote:
> >>As scheduled in Documentation/feature-removal-schedule.txt,
> >>remove "*50", "disable_hw_scan" module parameters and MODULE_ALIAS("iwl4965").
> >
> >Mostly fine, but for iwlegacy Stanislaw we want to keep hw scan (and it
> >was actually made default now)

Indeed, disable_hw_scan should be removed in iwlwifi but leaved in iwlegacy.

> Ok, I will wait for Stanislaw's response and then send an updated patch.

Have it now :-)

Stanislaw
