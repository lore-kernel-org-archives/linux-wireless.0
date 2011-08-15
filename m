Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab1HOILS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 04:11:18 -0400
Date: Mon, 15 Aug 2011 10:10:11 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: [PATCH 05/60] iwlagn: introduce struct iwl-shared - known by all
 layers
Message-ID: <20110815081010.GA3317@redhat.com> (sfid-20110815_101122_462553_18076B11)
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
 <1313257116-2697-6-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1313257116-2697-6-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 13, 2011 at 10:37:41AM -0700, Wey-Yi Guy wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> 
> This struct will hold pointers to all the layers, so that every layer will find
> the pointers it needs when calling another layer.
> 
> Note that the drv_data set to struct device is now a pointer to
> struct iwl_shared.

What for are you doing this? These changes through patch 60 seems
have no sense. You can easy use iwl_priv as structure shared between
all layers without any rewrite and making code more complex.

> This solves of bug that I introduced in
> 
> 	iwlagn: simplify the bus architecture

You should post bug fixes sparely.

Stanislaw
