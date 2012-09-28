Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57940 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952Ab2I1CZN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 22:25:13 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20581.2614.43943.601901@gargle.gargle.HOWL> (sfid-20120928_042517_404490_D826966D)
Date: Fri, 28 Sep 2012 07:53:50 +0530
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Antonio Quartulli <ordex@autistici.org>
Subject: [RFC 1/2] ath9k_htc: Advertize allowed vif combinations
In-Reply-To: <1348761132-8344-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1348761132-8344-1-git-send-email-mohammed@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan wrote:
> From: Antonio Quartulli <ordex@autistici.org>
> 
> Advertize allowed VIFs combinations to the cfg80211 sublayer.
> Other than that, practical tests shown that ath9k_htc devices allow an
> IBSS VIF to coexist with VIF set up on other modes, so advertize
> that to. We can also further add p2p/mesh mode to be advertized
> in the combinations allowed.

I don't think IBSS can co-exist with other op-modes.

Sujith
