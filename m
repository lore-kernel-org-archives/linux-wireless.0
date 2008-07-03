Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:5717 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbYGCBig (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 21:38:36 -0400
Subject: Re: [PATCH] iwlwifi: fix typo which caused iwl_get_tx_fail_reason
	to ever return an empty string
From: Zhu Yi <yi.zhu@intel.com>
To: Helmut Schaa <hschaa@suse.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	tomas.winkler@intel.com
In-Reply-To: <200807021217.06829.hschaa@suse.de>
References: <200807021217.06829.hschaa@suse.de>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 09:36:57 +0800
Message-Id: <1215049017.14590.517.camel@debian.sh.intel.com> (sfid-20080703_085915_910728_603AEE1F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-07-02 at 12:17 +0200, Helmut Schaa wrote:
> Fix a typo which caused iwl_get_tx_fail_reason to ever return an empty
> string.
> 
> Signed-off-by: Helmut Schaa <hschaa@suse.de>

ACK. Thanks a lot!

-yi

