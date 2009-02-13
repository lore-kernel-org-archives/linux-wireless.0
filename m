Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:62627 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538AbZBMW6G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 17:58:06 -0500
Subject: Re: [PATCH] compat-2.6: reflect changes to iwlwifi Kconfig file
From: reinette chatre <reinette.chatre@intel.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090213224937.GE4278@tesla>
References: <1234560857-32206-1-git-send-email-reinette.chatre@intel.com>
	 <20090213224937.GE4278@tesla>
Content-Type: text/plain
Date: Fri, 13 Feb 2009 15:01:51 -0800
Message-Id: <1234566111.31995.55.camel@rc-desk> (sfid-20090213_235811_589938_0CCC1A9F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-02-13 at 14:49 -0800, Luis R. Rodriguez wrote:
> On Fri, Feb 13, 2009 at 01:34:17PM -0800, Reinette Chatre wrote:
> > - CONFIG_IWLWIFI is now a tristate, select it to be 'm'
> > - CONFIG_IWLCORE has been removed
> > - CONFIG_IWLAGN_SPECTRUM_MEASUREMENT renamed to
> >   CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
> > - CONFIG_IWLAGN_LEDS has been removed (not used by driver)
> > - CONFIG_IWL3945_RFKILL does not exist
> > 
> > Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> 
> Thanks applied

Please wait on this ... this patch depends on recent patch to
wireless-testing that has not been applied yet.

Reinette

