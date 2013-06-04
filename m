Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:52066 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab3FDMHm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 08:07:42 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20909.55274.250284.971849@gargle.gargle.HOWL> (sfid-20130604_140745_750819_270522F7)
Date: Tue, 4 Jun 2013 17:34:58 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: Re: [PATCH 2/6] ath9k: Fix ANI monitoring
In-Reply-To: <20909.54790.725704.860717@gargle.gargle.HOWL>
References: <1370340695-29003-1-git-send-email-sujith@msujith.org>
	<1370340695-29003-2-git-send-email-sujith@msujith.org>
	<51ADD058.5000003@openwrt.org>
	<20909.54201.497575.556986@gargle.gargle.HOWL>
	<20909.54790.725704.860717@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan wrote:
> Actually, the changes appear to have been merged internally, for QCA988x.
> So, I am not sure if we can keep the ANI tweaks.

Let's see if there is any improvement in this bug with
these patches: https://bugzilla.kernel.org/show_bug.cgi?id=49201

Sujith
