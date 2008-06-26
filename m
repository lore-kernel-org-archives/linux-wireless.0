Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2802 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbYFZTrL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 15:47:11 -0400
Date: Thu, 26 Jun 2008 15:35:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	drago01 <drago01@gmail.com>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] iwl3945: use rfkill subsystem
Message-ID: <20080626193540.GA28598@tuxdriver.com> (sfid-20080626_214715_586929_351BDAFB)
References: <f6ca9fed0806160059l58286050wfeb6eda938f3a171@mail.gmail.com> <BD524EA7912ED5469DFD0BAEF6BC752F03D2C277@orsmsx411.amr.corp.intel.com> <1213783675.1312.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1213783675.1312.6.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 18, 2008 at 12:07:54PM +0200, Johannes Berg wrote:
> On Tue, 2008-06-17 at 19:34 -0700, Kolekar, Abhijeet wrote:
> > Added clearing the STATUS_EXIT_PENDING bit while ifup.
> > ACK.
> > 
> > The attached patch removes the sysfs interface from iwl3945 and uses
> > the rfkill subsystem instead.
> 
> > +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> > @@ -5913,7 +5913,9 @@ static void __iwl3945_down(struct iwl3945_priv
> > *priv)
> >  			       test_bit(STATUS_GEO_CONFIGURED,
> > &priv->status) <<
> >  					STATUS_GEO_CONFIGURED |
> >  			       test_bit(STATUS_IN_SUSPEND,
> 
> That patch is badly mangled by line-wrapping.

Can we have a non-damaged version of this patch?

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
