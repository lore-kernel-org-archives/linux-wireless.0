Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11187 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbcA1TCw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 14:02:52 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Peter Oh <poh@codeaurora.org>
CC: Michal Kazior <michal.kazior@tieto.com>,
	<ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 13/13] ath10k: implement push-pull tx
References: <1453384006-31907-1-git-send-email-michal.kazior@tieto.com>
	<1453384006-31907-14-git-send-email-michal.kazior@tieto.com>
	<56A1182A.4060309@codeaurora.org>
Date: Thu, 28 Jan 2016 10:36:20 +0200
In-Reply-To: <56A1182A.4060309@codeaurora.org> (Peter Oh's message of "Thu, 21
	Jan 2016 09:40:58 -0800")
Message-ID: <8737tim77f.fsf@kamboji.qca.qualcomm.com> (sfid-20160128_200256_214016_BF3DEE3F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <poh@codeaurora.org> writes:

>> +	spin_lock_bh(&ar->htt.tx_lock);
>> +	ath10k_mac_tx_lock(ar, ATH10K_TX_PAUSE_Q_FLUSH_PENDING);
>> +	spin_unlock_bh(&ar->htt.tx_lock);
>> +
>
> Isn't it proved it break Mesh from working?

Please think of others and edit your quotes, it was annoying to find
this oneliner from a 500+ line message.

-- 
Kalle Valo
