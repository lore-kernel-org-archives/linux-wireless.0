Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11625 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab2JOJsj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 05:48:39 -0400
From: Sujith Manoharan <c_manoha@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20603.55967.154275.896969@gargle.gargle.HOWL> (sfid-20121015_114843_098349_0E87938E)
Date: Mon, 15 Oct 2012 15:12:55 +0530
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: Sujith Manoharan <c_manoha@qti.qualcomm.com>,
	<linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 09/12] ath9k_hw: Configure new switch table for AR9565
 BTCOEX
In-Reply-To: <20121015094022.GC21551@hemis.qca.qualcomm.com>
References: <1350287738-18687-1-git-send-email-rmanohar@qca.qualcomm.com>
	<1350287738-18687-10-git-send-email-rmanohar@qca.qualcomm.com>
	<20603.54988.583810.352301@gargle.gargle.HOWL>
	<20121015094022.GC21551@hemis.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan wrote:
> I hate *_LATER macros. Its always confusing. Since SPDT is applicable only for
> 9462 & 9565, I remove the _LATER in v2.

The macros in ath9k are clean enough - they just check the macVersion.

Sujith
