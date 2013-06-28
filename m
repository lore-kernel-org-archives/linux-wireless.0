Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11751 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab3F1HKP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jun 2013 03:10:15 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH] ath10k: minimally handle new channel width enumeration values
References: <1372355538-19284-1-git-send-email-linville@tuxdriver.com>
Date: Fri, 28 Jun 2013 10:10:07 +0300
In-Reply-To: <1372355538-19284-1-git-send-email-linville@tuxdriver.com> (John
	W. Linville's message of "Thu, 27 Jun 2013 13:52:18 -0400")
Message-ID: <877ghek8xc.fsf@kamboji.qca.qualcomm.com> (sfid-20130628_091023_577449_405B87F6)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John W. Linville" <linville@tuxdriver.com> writes:

> From: "John W. Linville" <linville@tuxdriver.com>
>
>   CC      drivers/net/wireless/ath/ath10k/mac.o
> drivers/net/wireless/ath/ath10k/mac.c: In function ‘chan_to_phymode’:
> drivers/net/wireless/ath/ath10k/mac.c:229:3: warning: enumeration value ‘NL80211_CHAN_WIDTH_5’ not handled in switch [-Wswitch]
> drivers/net/wireless/ath/ath10k/mac.c:229:3: warning: enumeration value ‘NL80211_CHAN_WIDTH_10’ not handled in switch [-Wswitch]
> drivers/net/wireless/ath/ath10k/mac.c:247:3: warning: enumeration value ‘NL80211_CHAN_WIDTH_5’ not handled in switch [-Wswitch]
> drivers/net/wireless/ath/ath10k/mac.c:247:3: warning: enumeration value ‘NL80211_CHAN_WIDTH_10’ not handled in switch [-Wswitch]
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Looks good, thanks for fixing this while I'm on vacation. Strangely
enough we even had few warm days here in Finland! :)

-- 
Kalle Valo
