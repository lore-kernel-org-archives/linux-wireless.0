Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:8876 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757651Ab1GKRuA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2011 13:50:00 -0400
Subject: Re: [PATCH 18/21] iwlagn: allow application own the uCode operation
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1310405830.23469.5.camel@jlt3.sipsolutions.net>
References: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1310139989-27661-19-git-send-email-wey-yi.w.guy@intel.com>
	 (sfid-20110708_182055_559575_E91406E2)  <1310405830.23469.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jul 2011 10:15:27 -0700
Message-ID: <1310404527.24940.28.camel@wwguy-huron> (sfid-20110711_195014_297672_08359EBE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-07-11 at 10:37 -0700, Johannes Berg wrote:
> On Fri, 2011-07-08 at 08:46 -0700, Wey-Yi Guy wrote:
> 
> > +	struct iwl_priv *priv = hw->priv;
> > +	u8 owner;
> > +
> > +	if (!tb[IWL_TM_ATTR_UCODE_OWNER]) {
> 
> This causes a compile warning because iwl_testmode_cmd() has
> 	struct nlattr *tb[IWL_TM_ATTR_MAX - 1];
> 
> and the -1 shouldn't be there.
> 
ouch, I will submit separate patch to fix it.

Thanks
Wey
> 


