Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:9125 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183Ab0HRQqM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 12:46:12 -0400
Subject: Re: [PATCH 2/2] iwlwifi: do not spuriously call
 ieee80211_scan_completed
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Berg, Johannes" <johannes.berg@intel.com>
In-Reply-To: <20100818164405.GA2793@tuxdriver.com>
References: <1282149322-17928-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1282149322-17928-3-git-send-email-wey-yi.w.guy@intel.com>
	 <20100818164405.GA2793@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 09:50:34 -0700
Message-ID: <1282150234.4235.0.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-08-18 at 09:44 -0700, John W. Linville wrote:
> On Wed, Aug 18, 2010 at 09:35:22AM -0700, Wey-Yi Guy wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > When a scan is aborted because the corresponding
> > virtual interface is removed, we may still later
> > attempt to tell mac80211 that the scan completed.
> > This is obviously wrong, since we already told it
> > that it was aborted, so don't do that.
> > 
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> 
> Does this really qualify as a fix for 2.6.36?  Is it a regression?
> Does it generate an oops?  Or loss of connectivity?
> 
Johannes, could you help to answer.

Thanks
Wey


