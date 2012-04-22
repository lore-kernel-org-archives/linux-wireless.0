Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:6652 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915Ab2DVAjW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Apr 2012 20:39:22 -0400
Subject: Re: Missing iwlwifi firmwares ?
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Thomas Backlund <tmb@mageia.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4F9332EE.3030106@mageia.org>
References: <4F932A3D.2070701@mageia.org>
	 (sfid-20120421_235812_903118_31B5AB43) <1335045596.6516.8.camel@jlt3.sipsolutions.net>
	 <4F9332EE.3030106@mageia.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 Apr 2012 17:34:26 -0700
Message-ID: <1335054866.27767.172.camel@wwguy-huron> (sfid-20120422_023957_281407_DE604E00)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

it is already in the iwlwifi tree 
 http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi.git;a=summary

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Date: Wed, 11 Apr 2012 11:33:36 -0700
Subject: [PATCH 1/1] iwlwifi: use correct released ucode version

Report correctly the latest released version
of the iwlwifi firmware for all
iwlwifi-supported devices.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>

I will push it to 3.4 tomorrow.

Thanks
Wey

On Sun, 2012-04-22 at 01:21 +0300, Thomas Backlund wrote:
> 22.04.2012 00:59, Johannes Berg skrev:
> > On Sun, 2012-04-22 at 00:44 +0300, Thomas Backlund wrote:
> > 
> >> When reviewing our firmware packages I noticed a few missing iwlwifi
> >> firmwares according to kernel-3,3,1
> > 
> >> [...]
> >> firmware:       iwlwifi-6000g2a-6.ucode
> >> firmware:       iwlwifi-100-6.ucode
> >> firmware:       iwlwifi-1000-6.ucode
> >> [...]
> >>
> >> Theese three are missing from:
> >> http://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git;a=summary
> >>
> >> http://intellinuxwireless.org/?n=Downloads
> >>
> >>
> >> The API 5 ucodes are awailable, but the driver expect API 6...
> >>
> >> So..., when will they be available ?
> > 
> > We don't really know, but it was really just due to a bug in the driver,
> > it should use MODULE_FIRMWARE with the latest released rather than the
> > latest testing version -- there's a patch in our queue to fix that.
> > 
> > johannes
> > 
> 
> Any pointers to that patch ?
> 
> We are entering RC stage in less than 2 weeks.
> 
> --
> Thoma
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


