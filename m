Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:53421 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbYH1LjZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 07:39:25 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH 06/11] iwlwifi: fix apm_stop
Date: Thu, 28 Aug 2008 13:38:45 +0200
Cc: Zhu Yi <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com> <1219915510-3647-7-git-send-email-yi.zhu@intel.com> <1219926807.6064.17.camel@californication>
In-Reply-To: <1219926807.6064.17.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808281338.46894.mb@bu3sch.de> (sfid-20080828_133927_064971_49877D03)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 28 August 2008, Marcel Holtmann wrote:
> Hi Yi,
> 
> > The patch fixes CSR_GP_CNTRL_REG_FLAG_INIT_DONE was set instead of
> > cleared which disabled moving device to D0U state.
> 
> when was this mistake introduced. Is it a regression compared to what we
> have in 2.6.26?

I think you are overstretching the regression-fixes-only rule a little bit...
It will help nobody, if we don't fix actual _bugs_ and push such fixes
into the next merge window.

Our goal is to have a stable kernel on release. We don't get to that goal, if
we defer bugfixes to the next merge window.
