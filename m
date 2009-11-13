Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:4534 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473AbZKMBQ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 20:16:29 -0500
Subject: Re: [PATCH 1/2] ipw2100: Register the wiphy device
From: Zhu Yi <yi.zhu@intel.com>
To: "John W.Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Matthew Garrett <mjg@redhat.com>
In-Reply-To: <1258006767.31116.53.camel@debian>
References: <1257968191-495-1-git-send-email-mjg@redhat.com>
	 <1258006767.31116.53.camel@debian>
Content-Type: text/plain
Date: Fri, 13 Nov 2009 09:16:30 +0800
Message-Id: <1258074990.31116.1052.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-11-12 at 14:19 +0800, Zhu Yi wrote:
> On Thu, 2009-11-12 at 03:36 +0800, Matthew Garrett wrote:
> > libipw unconditionally calls wiphy_unregister, but it's up to the driver
> > to register it in the first place. ipw2100 fails to do so. Add the necessary
> > glue code, and also ensure that rfkill statuses get set up appropriately.
> > 
> > Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 
> Acked-by: Zhu Yi <yi.zhu@intel.com>
> 
> Thanks for the fix. BTW, have you already tried [1] for the firmware
> missing case?
> 
> 1. http://marc.info/?l=linux-wireless&m=125775901909164&w=2

John, both of these patches are for 32-rc7.

Thanks,
-yi

