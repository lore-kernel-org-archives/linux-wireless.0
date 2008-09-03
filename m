Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43356
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755257AbYICDfJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:35:09 -0400
Date: Tue, 02 Sep 2008 20:35:02 -0700 (PDT)
Message-Id: <20080902.203502.46334170.davem@davemloft.net> (sfid-20080903_055041_205697_1657A68B)
To: yi.zhu@intel.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ron.rindjunsky@intel.com, ben.m.cahill@intel.com,
	tomas.winkler@intel.com
Subject: Re: [PATCH 2/9] iwlwifi: fix hidden ssid discovery in passive
 channels
From: David Miller <davem@davemloft.net>
In-Reply-To: <1220411930-15216-3-git-send-email-yi.zhu@intel.com>
References: <1220411930-15216-1-git-send-email-yi.zhu@intel.com>
	<1220411930-15216-2-git-send-email-yi.zhu@intel.com>
	<1220411930-15216-3-git-send-email-yi.zhu@intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>
Date: Wed,  3 Sep 2008 11:18:43 +0800

> From: Ron Rindjunsky <ron.rindjunsky@intel.com>
> 
> This enables sending of direct probes on passive channels, as long as
> traffic was detected on that channel. This enables connectivity to
> hidden/non broadcasting SSIDs APs on passive channels. Note 5000 HW
> declares all 5.2 spectrum as passive.
> 
> Signed-off-by: Cahill Ben <ben.m.cahill@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>

Acked-by: David S. Miller <davem@davemloft.net>
