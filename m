Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36535 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab2KSOJN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 09:09:13 -0500
Message-ID: <1353334181.18299.1.camel@jlt4.sipsolutions.net> (sfid-20121119_150918_992461_AD0AEBFD)
Subject: Re: [PATCH 1/1] iwlwifi: Remove duplicate inclusion of iwl-trans.h
 in pcie/drv.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	ilw@linux.intel.com, wey-yi.w.guy@intel.com, patches@linaro.org
Date: Mon, 19 Nov 2012 15:09:41 +0100
In-Reply-To: <1353325540-9338-1-git-send-email-sachin.kamat@linaro.org> (sfid-20121119_125157_651111_5B3E39AD)
References: <1353325540-9338-1-git-send-email-sachin.kamat@linaro.org>
	 (sfid-20121119_125157_651111_5B3E39AD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-19 at 17:15 +0530, Sachin Kamat wrote:
> iwl-trans.h was included twice.

Thanks, I've picked this up.

johannes

