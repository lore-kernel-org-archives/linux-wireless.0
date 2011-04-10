Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:5097 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754449Ab1DJP5E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 11:57:04 -0400
Subject: Re: [PATCH 04/16] iwlwifi: fix bugs in change_interface
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1302423352.3519.5.camel@jlt3.sipsolutions.net>
References: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1302276636-12802-5-git-send-email-wey-yi.w.guy@intel.com>
	 <1302423352.3519.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Apr 2011 08:37:13 -0700
Message-ID: <1302449833.14995.135.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-04-10 at 01:15 -0700, Johannes Berg wrote:
> On Fri, 2011-04-08 at 08:30 -0700, Wey-Yi Guy wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > If change_interface gets invoked during a firmware
> > restart, it may crash; prevent that from happening
> > by checking if ctx->vif is assigned.
> > 
> > Additionally, in my initial commit I forgot to set
> > the vif->p2p variable correctly, so fix that too.
> > 
> > Cc: stable@kernel.org [2.6.38+]
> 
> This should go into .39 as well.


> Yes, you are right.

John, would you like me to re-submit?

thanks
>  
> 
> 


