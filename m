Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:16109 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbbC3QVY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 12:21:24 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v5 2/7] ath10k: implement chanctx API
References: <1427200993-7550-1-git-send-email-michal.kazior@tieto.com>
	<1427200993-7550-3-git-send-email-michal.kazior@tieto.com>
Date: Mon, 30 Mar 2015 19:21:10 +0300
In-Reply-To: <1427200993-7550-3-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 24 Mar 2015 12:43:08 +0000")
Message-ID: <87iodi318p.fsf@kamboji.qca.qualcomm.com> (sfid-20150330_182128_032912_D78B4CF3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The chanctx API will allow ath10k to support
> multi-channel operation.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

kbuild reports:

sparse warnings: (new ones prefixed by >>)

>> drivers/net/wireless/ath/ath10k/mac.h:72:57: sparse: incorrect type in initializer (different address spaces)
   drivers/net/wireless/ath/ath10k/mac.h:72:57:    expected struct ieee80211_chanctx_conf *conf
   drivers/net/wireless/ath/ath10k/mac.h:72:57:    got struct ieee80211_chanctx_conf [noderef] <asn:4>*chanctx_conf
>> drivers/net/wireless/ath/ath10k/mac.h:72:57: sparse: incorrect type in initializer (different address spaces)
   drivers/net/wireless/ath/ath10k/mac.h:72:57:    expected struct ieee80211_chanctx_conf *conf
   drivers/net/wireless/ath/ath10k/mac.h:72:57:    got struct ieee80211_chanctx_conf [noderef] <asn:4>*chanctx_conf
>> drivers/net/wireless/ath/ath10k/mac.h:72:57: sparse: incorrect type in initializer (different address spaces)
   drivers/net/wireless/ath/ath10k/mac.h:72:57:    expected struct ieee80211_chanctx_conf *conf
   drivers/net/wireless/ath/ath10k/mac.h:72:57:    got struct ieee80211_chanctx_conf [noderef] <asn:4>*chanctx_conf
>> drivers/net/wireless/ath/ath10k/mac.h:72:57: sparse: incorrect type in initializer (different address spaces)
   drivers/net/wireless/ath/ath10k/mac.h:72:57:    expected struct ieee80211_chanctx_conf *conf
   drivers/net/wireless/ath/ath10k/mac.h:72:57:    got struct ieee80211_chanctx_conf [noderef] <asn:4>*chanctx_conf
>> drivers/net/wireless/ath/ath10k/mac.h:72:57: sparse: incorrect type in initializer (different address spaces)
   drivers/net/wireless/ath/ath10k/mac.h:72:57:    expected struct ieee80211_chanctx_conf *conf
   drivers/net/wireless/ath/ath10k/mac.h:72:57:    got struct ieee80211_chanctx_conf [noderef] <asn:4>*chanctx_conf
>> drivers/net/wireless/ath/ath10k/mac.h:72:57: sparse: incorrect type in initializer (different address spaces)
   drivers/net/wireless/ath/ath10k/mac.h:72:57:    expected struct ieee80211_chanctx_conf *conf
   drivers/net/wireless/ath/ath10k/mac.h:72:57:    got struct ieee80211_chanctx_conf [noderef] <asn:4>*chanctx_conf
>> drivers/net/wireless/ath/ath10k/mac.h:72:57: sparse: incorrect type in initializer (different address spaces)
   drivers/net/wireless/ath/ath10k/mac.h:72:57:    expected struct ieee80211_chanctx_conf *conf
   drivers/net/wireless/ath/ath10k/mac.h:72:57:    got struct ieee80211_chanctx_conf [noderef] <asn:4>*chanctx_conf
--
>> drivers/net/wireless/ath/ath10k/mac.h:72:57: sparse: incorrect type in initializer (different address spaces)                                                                                                                                                                                                               
   drivers/net/wireless/ath/ath10k/mac.h:72:57:    expected struct ieee80211_chanctx_conf *conf                                                                                                                                                                                                                                
   drivers/net/wireless/ath/ath10k/mac.h:72:57:    got struct ieee80211_chanctx_conf [noderef] <asn:4>*chanctx_conf                                                                                                                                                                                                            
>> drivers/net/wireless/ath/ath10k/mac.h:72:57: sparse: incorrect type in initializer (different address spaces)                                                                                                                                                                                                               
   drivers/net/wireless/ath/ath10k/mac.h:72:57:    expected struct ieee80211_chanctx_conf *conf                                                                                                                                                                                                                                
   drivers/net/wireless/ath/ath10k/mac.h:72:57:    got struct ieee80211_chanctx_conf [noderef] <asn:4>*chanctx_conf                                   

-- 
Kalle Valo
