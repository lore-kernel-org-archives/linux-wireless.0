Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:44671 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbYH1K4l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 06:56:41 -0400
Subject: Re: [PATCH 08/11] iwlwifi: call apm stop on exit
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Zhu Yi <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	Gregory Greenman <gregory.greenman@intel.com>,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
In-Reply-To: <1219920741.25321.4.camel@johannes.berg>
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-2-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-3-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-4-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-5-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-6-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-7-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-8-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-9-git-send-email-yi.zhu@intel.com>
	 <1219927149.6064.25.camel@californication>
	 (sfid-20080828_123916_214502_EDFC473D)  <1219920741.25321.4.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 28 Aug 2008 14:56:35 +0200
Message-Id: <1219928195.6064.43.camel@californication> (sfid-20080828_125652_407270_AA0950A3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > > This patch calls apm stop on exit and suspend and sets STATUS_EXIT_PENDING
> > > accordingly. Without this patch hardware consumes power even after driver
> > > is removed or suspended.
> > 
> > is this a regression to 2.6.26? That is always the important question
> > here since that will determine if the patch should go in. If the 2.6.26
> > version did this better (even if not prefect), then this patch should go
> > on, otherwise it could wait until next merge window.
> 
> AFAIR people have been complaining about this behaviour _forever_, so
> it's hardly a regression.

I think so too. However the question is still if 2.6.26 maybe did better
and we are now doing worse because of other patches. This needs to be in
the commit message. Otherwise this falls for me in the next merge window
category.

Regards

Marcel


