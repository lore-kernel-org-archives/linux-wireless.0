Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4929 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab2JOJwf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 05:52:35 -0400
Date: Mon, 15 Oct 2012 15:20:13 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Sujith Manoharan <c_manoha@qti.qualcomm.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 09/12] ath9k_hw: Configure new switch table for AR9565
 BTCOEX
Message-ID: <20121015095012.GA21952@hemis.qca.qualcomm.com> (sfid-20121015_115239_496695_DD9AD9B0)
References: <1350287738-18687-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1350287738-18687-10-git-send-email-rmanohar@qca.qualcomm.com>
 <20603.54988.583810.352301@gargle.gargle.HOWL>
 <20121015094022.GC21551@hemis.qca.qualcomm.com>
 <20603.55967.154275.896969@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20603.55967.154275.896969@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 15, 2012 at 03:12:55PM +0530, Sujith Manoharan wrote:
> Rajkumar Manoharan wrote:
> > I hate *_LATER macros. Its always confusing. Since SPDT is applicable only for
> > 9462 & 9565, I remove the _LATER in v2.
> 
> The macros in ath9k are clean enough - they just check the macVersion.
>
I mean AR9462_20_OR_LATER that checks macRev which is different from other *_LATER macros.
So I'll remove AR9462_20_OR_LATER to avoid confusion.

-Rajkumar
