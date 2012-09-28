Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21296 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab2I1Kmk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2012 06:42:40 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20581.32544.134606.56158@gargle.gargle.HOWL> (sfid-20120928_124243_762532_55DA13C0)
Date: Fri, 28 Sep 2012 16:12:40 +0530
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: Sujith Manoharan <c_manoha@qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Antonio Quartulli <ordex@autistici.org>
Subject: Re: [RFC 1/2] ath9k_htc: Advertize allowed vif combinations
In-Reply-To: <50652E56.10303@qca.qualcomm.com>
References: <1348761132-8344-1-git-send-email-mohammed@qca.qualcomm.com>
	<20581.2614.43943.601901@gargle.gargle.HOWL>
	<50652E56.10303@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan wrote:
> oh yeah, you are saying that we will have some issues with IBSS
> coexistence with other modes because of TSF sync.

Yes, this is a problem.

Sujith
