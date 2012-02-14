Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40389 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab2BNJXc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 04:23:32 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20282.10258.858715.688562@gargle.gargle.HOWL> (sfid-20120214_102337_928910_46E71AD0)
Date: Tue, 14 Feb 2012 14:53:30 +0530
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH 3/4] ath9k: Modify CCK spur mitigation for AR9462
In-Reply-To: <CAD2nsn3sVaAea1iBRAgp7-j733BznjrB6sU_i5V1SZ0_kpC1fA@mail.gmail.com>
References: <20282.7600.287048.11418@gargle.gargle.HOWL>
	<CAD2nsn3sVaAea1iBRAgp7-j733BznjrB6sU_i5V1SZ0_kpC1fA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi wrote:
> i saw this some time back ,the check will not take care of this logic
> 
> if (AR_SREV_9462(ah) && (i == 0 || i == 3))
> 			continue;

Yep, looks like this is already handled. Thanks for catching this.

Sujith
