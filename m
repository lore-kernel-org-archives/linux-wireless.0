Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21032 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862AbbCSNzw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2015 09:55:52 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: setup maximum number of supported stations
References: <1426162301-27066-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Thu, 19 Mar 2015 15:55:43 +0200
In-Reply-To: <1426162301-27066-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Thu, 12 Mar 2015 13:11:41 +0100")
Message-ID: <87sid1hz1c.fsf@kamboji.qca.qualcomm.com> (sfid-20150319_145557_668372_3C7EAF4C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Setup maximum number of associated stations supported in
> AP/P2P_GO mode.
>
> This allow hostapd/wpa_supplicant to play with that limit
> and set more information (eg. P2P group limit bit for P2P_GO).
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Thanks, applied.

-- 
Kalle Valo
