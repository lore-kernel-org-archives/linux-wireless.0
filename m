Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:17697 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754454Ab2DSRKy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 13:10:54 -0400
Subject: Re: [PATCH] iwlwifi: add option to disable 5GHz band
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1334851014.16897.297.camel@aeonflux>
References: <1334830280-3019-1-git-send-email-sgruszka@redhat.com>
	 <4F901F51.3000704@sipsolutions.net>  <1334851014.16897.297.camel@aeonflux>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Apr 2012 10:06:17 -0700
Message-ID: <1334855177.27767.152.camel@wwguy-huron> (sfid-20120419_191057_784449_681F3C40)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-04-19 at 17:56 +0200, Marcel Holtmann wrote:
> Hi Johannes,
> 
> > > There are various problems happened on 5GHz band not observed on
> > > 2.4 GHz (microcode errors, queue stuck, etc... ) . Also roaming
> > > between 5GHz AP and 2GHz does not work very well. To workaround
> > > the problems add option to disable 5GHz support. This will help
> > > on environments where APs are dual-band, and devices will not try
> > > to associate on band where issues happen.
> > 
> > Would it make sense to somehow do this in cfg80211? Today, our driver 
> > may be the only one having this problem (which I've never really heard 
> > about?), but is it always going to be?
> 
> honestly I have seen 5GHz problems with our driver multiple times. I
> always ended up disabling 5GHz support in the AP since I rarely have
> time to debug this. It only happens after long time of operation for me,
> but was like super annoying all the time.
> 
> And I had similar issues with N support.
> 
> I would personally be fine with a global debugfs option within cfg80211
> to disable it.
> 
> Regards
> 
I don't see it hurt we have the option to disable the %GHz support in
iwlwifi. We could always change it later.

Thanks
Wey

