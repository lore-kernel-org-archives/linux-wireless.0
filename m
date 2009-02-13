Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:26152 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479AbZBMWuW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 17:50:22 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2009 14:50:22 -0800
Date: Fri, 13 Feb 2009 14:49:37 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] compat-2.6: reflect changes to iwlwifi Kconfig file
Message-ID: <20090213224937.GE4278@tesla> (sfid-20090213_235029_323300_1230EC9E)
References: <1234560857-32206-1-git-send-email-reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1234560857-32206-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 13, 2009 at 01:34:17PM -0800, Reinette Chatre wrote:
> - CONFIG_IWLWIFI is now a tristate, select it to be 'm'
> - CONFIG_IWLCORE has been removed
> - CONFIG_IWLAGN_SPECTRUM_MEASUREMENT renamed to
>   CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
> - CONFIG_IWLAGN_LEDS has been removed (not used by driver)
> - CONFIG_IWL3945_RFKILL does not exist
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Thanks applied

  Luis
