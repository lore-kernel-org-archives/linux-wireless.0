Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44573 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbaEVOle (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 10:41:34 -0400
Message-ID: <1400769683.4174.25.camel@jlt4.sipsolutions.net> (sfid-20140522_164137_243101_AB66AEF1)
Subject: Re: [PATCH 2/2] ath10k: make core registering async
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Date: Thu, 22 May 2014 16:41:23 +0200
In-Reply-To: <1400767955-16313-3-git-send-email-michal.kazior@tieto.com> (sfid-20140522_161951_842720_A62CA123)
References: <1400767955-16313-1-git-send-email-michal.kazior@tieto.com>
	 <1400767955-16313-3-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140522_161951_842720_A62CA123)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-05-22 at 16:12 +0200, Michal Kazior wrote:

> As a side effect there's no way to propagate
> registering errors to the pci subsystem but this
> probably isn't really necessary.

You should probably unbind if it fails - iwlwifi does that.

johannes

