Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:58239 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932082Ab1IRVHT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Sep 2011 17:07:19 -0400
Subject: Re: problem with intel 5300
From: wwguy <wey-yi.w.guy@intel.com>
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1109170753250.13829@uplift.swm.pp.se>
References: <alpine.DEB.2.00.1109100736280.13538@uplift.swm.pp.se>
	 <1315667365.3547.20.camel@wwguy-huron>
	 <alpine.DEB.2.00.1109102219380.13829@uplift.swm.pp.se>
	 <alpine.DEB.2.00.1109170753250.13829@uplift.swm.pp.se>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 18 Sep 2011 14:02:00 -0700
Message-ID: <1316379720.29243.29.camel@wwguy-ubuntu> (sfid-20110918_230723_286487_4EDFFB2E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-09-16 at 22:53 -0700, Mikael Abrahamsson wrote:
> On Sat, 10 Sep 2011, Mikael Abrahamsson wrote:
> 
> > On Sat, 10 Sep 2011, Guy, Wey-Yi wrote:
> >
> >> 2. use module parameter wd_disable=1 to avoid firmware reload and go
> >> into "deep sleep"
> >
> > I'm going with number 2 here, will report back if it didn't work.
> 
> When I try that, I get:
> 
> iwlagn: Unknown parameter `wd_disable'
> 

what module parameters option you have
when you do the following

$modinfo iwlagn

Thanks
Wey


