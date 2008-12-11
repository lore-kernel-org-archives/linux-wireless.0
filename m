Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44656 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756434AbYLKRPh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 12:15:37 -0500
Subject: Re: [PATCH ] iwlwifi: fix build warning (iwl-rx.c)
From: reinette chatre <reinette.chatre@intel.com>
To: Rami Rosen <ramirose@gmail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <eb3ff54b0812110429y7d18e8cfx28a6da6637da23cf@mail.gmail.com>
References: <eb3ff54b0812110429y7d18e8cfx28a6da6637da23cf@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 11 Dec 2008 09:16:41 -0800
Message-Id: <1229015801.18730.211.camel@rc-desk> (sfid-20081211_181540_122221_A7B0186C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-12-11 at 04:29 -0800, Rami Rosen wrote:
> This patch fixes the following build warning when CONFIG_IWLWIFI_DEBUG
> is not set.
> 
> /work/src/wireless-testing/drivers/net/wireless/iwlwifi/iwl-rx.c:758:
> warning: 'iwl_dbg_report_frame' defined but not used
> 
> 
> (wireless-testing).
> 
> Signed-off-by: Rami Rosen <ramirose@gmail.com>

Thank you

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette


