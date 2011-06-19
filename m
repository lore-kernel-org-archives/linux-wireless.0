Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:53183 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189Ab1FSQJX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2011 12:09:23 -0400
Subject: Re: [PATCH 01/18] iwlagn: usersapce application decide the size of
 trace buffer
From: wwguy <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1308470852.4145.2.camel@jlt3.sipsolutions.net>
References: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1307802352-16398-2-git-send-email-wey-yi.w.guy@intel.com>
	 (sfid-20110611_165547_476196_E1FC1744)  <1308470852.4145.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Jun 2011 09:05:37 -0700
Message-ID: <1308499537.31756.14.camel@wwguy-ubuntu> (sfid-20110619_180931_923009_80DC45AF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-06-19 at 01:07 -0700, Johannes Berg wrote:
> On Sat, 2011-06-11 at 07:25 -0700, Wey-Yi Guy wrote:
> 
> > +++ b/drivers/net/wireless/iwlwifi/iwl-testmode.h
> > @@ -167,6 +167,7 @@ enum iwl_tm_attr_t {
> >  	 */
> >  	IWL_TM_ATTR_TRACE_ADDR,
> >  	IWL_TM_ATTR_TRACE_DATA,
> > +	IWL_TM_ATTR_TRACE_SIZE,
> >  
> >  	/* When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_FIXRATE_REQ,
> >  	 * The mandatory fields are:
> 
> I know that currently there are no applications, but I really think we
> need to be much more careful about this as it is quickly becoming ABI,
> so you can't just insert attributes in the middle.
> 
point taken, I will continue work in this area and will try to see how
to address this issue in my following patches

Thanks
Wey
> 


