Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:36098 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab3FDL7i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 07:59:38 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20909.54790.725704.860717@gargle.gargle.HOWL> (sfid-20130604_135941_703802_20CAC4A5)
Date: Tue, 4 Jun 2013 17:26:54 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: Re: [PATCH 2/6] ath9k: Fix ANI monitoring
In-Reply-To: <20909.54201.497575.556986@gargle.gargle.HOWL>
References: <1370340695-29003-1-git-send-email-sujith@msujith.org>
	<1370340695-29003-2-git-send-email-sujith@msujith.org>
	<51ADD058.5000003@openwrt.org>
	<20909.54201.497575.556986@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan wrote:
> > With this patch, the raise-limit is always 3500, you should change it to
> > 1000 when removing the above-/below-INI distinction.
> 
> Thanks, I'll fix this and send a v2.

Actually, the changes appear to have been merged internally, for QCA988x.
So, I am not sure if we can keep the ANI tweaks.

Sujith
