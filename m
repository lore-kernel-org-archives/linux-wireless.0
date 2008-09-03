Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43352
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755257AbYICDer (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:34:47 -0400
Date: Tue, 02 Sep 2008 20:34:40 -0700 (PDT)
Message-Id: <20080902.203440.216468929.davem@davemloft.net> (sfid-20080903_055041_969061_23B1DC08)
To: yi.zhu@intel.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	assaf.krauss@intel.com, tomas.winkler@intel.com
Subject: Re: [PATCH 1/9] iwlwifi: W/A for the TSF correction in IBSS
From: David Miller <davem@davemloft.net>
In-Reply-To: <1220411930-15216-2-git-send-email-yi.zhu@intel.com>
References: <1220411930-15216-1-git-send-email-yi.zhu@intel.com>
	<1220411930-15216-2-git-send-email-yi.zhu@intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>
Date: Wed,  3 Sep 2008 11:18:42 +0800

> From: Assaf Krauss <assaf.krauss@intel.com>
> 
> This patch is a W/A for the TSF sync issue in IBSS merging. HW is not
> capable to sync TSF (it's constantly little behind). This creates
> constant IBSS merging upon reception of each beacon, adding and removing
> station which in turn creates above 50% packet loss and thus dramatically
> degrade the throughput. The W/A simply stops the driver from declaring it
> has a reliable TSF value and thus eliminates IBSS merging.
> 
> Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>

Acked-by: David S. Miller <davem@davemloft.net>
