Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31902 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbcEISHa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2016 14:07:30 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH 1/3] ath9k: reuse ar9003_hw_tx_power_regwrite for tx99
 setup
Date: Mon, 9 May 2016 18:07:17 +0000
Message-ID: <87eg9bhzqi.fsf@kamboji.qca.qualcomm.com> (sfid-20160509_200737_904845_743FBB35)
References: <1461854706-10494-1-git-send-email-helmut.schaa@googlemail.com>
In-Reply-To: <1461854706-10494-1-git-send-email-helmut.schaa@googlemail.com>
	(Helmut Schaa's message of "Thu, 28 Apr 2016 16:45:04 +0200")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helmut Schaa <helmut.schaa@googlemail.com> writes:

> The same functionality as ar9003_hw_tx_power_regwrite is hardcoded in
> ar9003_hw_tx99_set_txpower. Just reuse the existing ar9003_hw_tx_power_regwrite
> for TX99 setup too.
>
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

Thanks, 3 patches applied to ath.git:

8569f5915456 ath9k: reuse ar9003_hw_tx_power_regwrite for tx99 setup
e7ae328961ff ath9k: Move TX99 config option under ath9k debugging
b0291715d31c ath9k: Simplify ar9003_hw_tx99_set_txpower

-- 
Kalle Valo