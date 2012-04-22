Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:24097 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab2DVO0G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Apr 2012 10:26:06 -0400
Subject: Re: Missing iwlwifi firmwares ?
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Thomas Backlund <tmb@mageia.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4F93D264.6060905@mageia.org>
References: <4F932A3D.2070701@mageia.org>
	 (sfid-20120421_235812_903118_31B5AB43) <1335045596.6516.8.camel@jlt3.sipsolutions.net>
	 <4F9332EE.3030106@mageia.org> <1335054866.27767.172.camel@wwguy-huron>
	 <4F93D264.6060905@mageia.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 Apr 2012 07:21:04 -0700
Message-ID: <1335104464.27767.173.camel@wwguy-huron> (sfid-20120422_162611_320333_14E8FEA2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-04-22 at 12:41 +0300, Thomas Backlund wrote:
> 22.04.2012 03:34, Guy, Wey-Yi skrev:
> > it is already in the iwlwifi tree 
> >  http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi.git;a=summary
> > 
> > From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
> > Date: Wed, 11 Apr 2012 11:33:36 -0700
> > Subject: [PATCH 1/1] iwlwifi: use correct released ucode version
> > 
> > Report correctly the latest released version
> > of the iwlwifi firmware for all
> > iwlwifi-supported devices.
> > 
> > Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
> > Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > 
> > I will push it to 3.4 tomorrow.
> > 
> > Thanks
> > Wey
> 
> 
> Found it, thanks!
> 
> btw, shouldn't that patch have a cc: stable@ for atleast 3.3 ?
> 
Yes, I am preparing the patch to push today

Thanks
Wey

