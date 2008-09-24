Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37676 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbYIXTRI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2008 15:17:08 -0400
Date: Wed, 24 Sep 2008 15:16:34 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: johannes@sipsolutions.net, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: [PATCH 1/1] iwlwifi 2.6.27: send all the calibration results
	instead of the last one only
Message-ID: <20080924191634.GB3639@tuxdriver.com> (sfid-20080924_211716_166552_9C0630F5)
References: <1222128868-16763-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1222128868-16763-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 23, 2008 at 03:14:28AM +0300, Tomas Winkler wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> 
> This patch solves a bug in calibration. We get three results from the
> initial microcode, but we freed all the results upon each reception leading
> to zero two of them, only the last one survived. This fix is user visible in
> HT rates.
> 
> This patch simplifed version for 2.6.27 and will create conflict with 
> 86316f2fe474b019cc445211980f5394977b34d5 iwlwifi: generic init calibrations framework

The code is different in wireless-next-2.6.  Does this problem exist there?

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
