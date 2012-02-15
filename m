Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33381 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060Ab2BOR7l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 12:59:41 -0500
Subject: Re: [PATCH] iwlwifi: iwl-agn.h included twice
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: linux-wireless@vger.kernel.org, Danny Kukawka <dkukawka@suse.de>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1329328516-4792-1-git-send-email-danny.kukawka@bisect.de>
References: <1329328516-4792-1-git-send-email-danny.kukawka@bisect.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Feb 2012 08:50:09 -0800
Message-ID: <1329324609.7290.67.camel@wwguy-huron> (sfid-20120215_190000_236066_1532F2F5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-02-15 at 18:55 +0100, Danny Kukawka wrote:
> drivers/net/wireless/iwlwifi/iwl-core.c included 'iwl-agn.h' twice,
> remove the duplicate.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>

