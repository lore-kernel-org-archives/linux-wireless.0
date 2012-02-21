Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10612 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab2BUONT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Feb 2012 09:13:19 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20291.42604.545286.901746@gargle.gargle.HOWL> (sfid-20120221_151323_327059_5322B456)
Date: Tue, 21 Feb 2012 19:43:00 +0530
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: Re: [RFC/WIP 09/22] ath9k: Initialize BTCOEX scheme using a helper
In-Reply-To: <CAD2nsn2bPffcbPcJAn1BG25Q-XTR8sJCHFwh_siGmneme7JpYQ@mail.gmail.com>
References: <20291.25199.584747.537695@gargle.gargle.HOWL>
	<CAD2nsn2bPffcbPcJAn1BG25Q-XTR8sJCHFwh_siGmneme7JpYQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi wrote:
> is it possible to move it to gpio.c, except we are initializing btcoex
> related GPIO pins so logically gpio.c could be a good idea. pls let me
> know if i had missed something

The coex parameters in ath_hw are initialized, so btcoex.c is okay.

Sujith
