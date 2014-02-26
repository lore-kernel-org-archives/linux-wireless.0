Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:36284 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbaBZQdo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 11:33:44 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2] ath10k: implement drv_get_tsf for ibss merging
References: <1392351895-20495-1-git-send-email-yeohchunyeow@gmail.com>
Date: Wed, 26 Feb 2014 18:33:38 +0200
In-Reply-To: <1392351895-20495-1-git-send-email-yeohchunyeow@gmail.com>
	(Chun-Yeow Yeoh's message of "Fri, 14 Feb 2014 12:24:55 +0800")
Message-ID: <878usxn89p.fsf@kamboji.qca.qualcomm.com> (sfid-20140226_173401_902563_E8D6FCB5)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chun-Yeow Yeoh <yeohchunyeow@gmail.com> writes:

> Implement the get TSF by simply returning 0 so that IBSS
> merging is happening. Otherwise, IBSS nodes that have similar
> SSID naming won't merge. This is simply fooling the mac80211
> that the TSF in the received beacon is higher than the local TSF.
>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>

Thanks, applied.

-- 
Kalle Valo
