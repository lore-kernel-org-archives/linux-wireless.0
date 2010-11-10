Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:3958 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242Ab0KJSv0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 13:51:26 -0500
Subject: Re: [PATCH 00/16] update for 2.6.37
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20101110181609.GB2714@tuxdriver.com>
References: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
	 <20101110181609.GB2714@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 10:47:16 -0800
Message-ID: <1289414836.12056.88.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Wed, 2010-11-10 at 10:16 -0800, John W. Linville wrote:
> On Wed, Nov 10, 2010 at 09:56:34AM -0800, Wey-Yi Guy wrote:
> > We make the correction for the latest PCI ID used for multiple NICs
> > We also fix the low tpt problem cause by mac80211 changes
> > Number of code clean up to separate new agn devices from legacy devices
> > 
> > Johannes Berg (5):
> >   iwlagn: fix non-5000+ build
> >   iwlagn: fix needed chains calculation
> >   iwlagn: fix RXON issues
> >   iwlagn: re-enable calibration
> >   iwlagn: fix RXON HT
> > 
> > Shanyu Zhao (2):
> >   iwlwifi: seperate disconnected antenna function
> >   iwlwifi: disable disconnected antenna for advanced bt coex
> > 
> > Wey-Yi Guy (8):
> >   iwlagn: update PCI ID for 6000g2b series devices
> >   iwlagn: update PCI ID for 6000g2a series devices
> >   iwlagn: update PCI ID for 100 series devices
> >   iwlwifi: Legacy isr only used by legacy devices
> >   iwlwifi: put all the isr related function under ops
> >   iwlwifi: legacy tx_cmd_protection function
> >   iwlwifi: resending QoS command when HT changes
> >   iwlagn: enabel shadow register
> > 
> > Winkler, Tomas (1):
> >   iwlwlifi: update rx write pointer w/o request mac access in the CAM
> >     mode
> 
> Is this really intended for 2.6.37?  Some of these might be
> appropriate, although at first glance even some of the fixes may be
> for code in -next.
> 
> Fixes only for 2.6.37 -- it has been that way for weeks.  Perhaps you
> actually intended this for 2.6.38?
> 
Oops, it is for 2.6.38, I forgot to change the "Subject", sorry.

Wey


