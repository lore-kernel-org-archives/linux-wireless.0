Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7138 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab3GOHhQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 03:37:16 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: pass also QOS Null frames through mgmt tx path
References: <1373624746-3244-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Mon, 15 Jul 2013 10:37:08 +0300
In-Reply-To: <1373624746-3244-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Fri, 12 Jul 2013 12:25:46 +0200")
Message-ID: <87mwpop93v.fsf@kamboji.qca.qualcomm.com> (sfid-20130715_093720_849588_23C1832A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Fw will report wrong tx status for QOS Null frames
> sent through data tx path.
>
> This patch fixes station(s) keep alive detection
> triggered from wpa_supplicant/hostapd when work
> as AP/GO and WMM enabled.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

I think you mentioned privately that this patch should be dropped. Is
that still the case?

-- 
Kalle Valo
