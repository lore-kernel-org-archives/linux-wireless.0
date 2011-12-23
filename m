Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37073 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab1LWNhh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 08:37:37 -0500
Received: by ggdk6 with SMTP id k6so6815770ggd.19
        for <linux-wireless@vger.kernel.org>; Fri, 23 Dec 2011 05:37:37 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20212.33798.546957.802311@gargle.gargle.HOWL> (sfid-20111223_143741_044171_7A04A072)
Date: Fri, 23 Dec 2011 19:07:10 +0530
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Fix panic when setting a channel
In-Reply-To: <4EF480C4.8040104@qca.qualcomm.com>
References: <20210.53767.139322.166202@gargle.gargle.HOWL>
	<4EF480C4.8040104@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo wrote:
> Thanks, patch applied.
> 
> When does this happen in practise? It's always good to document the
> actual (user visible) bug the patch fixes.

iw dev wlan0 set channel 1

:-)

Sujith
