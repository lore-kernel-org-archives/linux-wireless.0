Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47323 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbcCXQNd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2016 12:13:33 -0400
From: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rmanohar@codeaurora.org" <rmanohar@codeaurora.org>
Subject: Re: [PATCH 1/9] ath10k: speedup htt rx descriptor processing for tx
 completion
Date: Thu, 24 Mar 2016 16:13:25 +0000
Message-ID: <1458836004642.18784@qti.qualcomm.com> (sfid-20160324_171336_809494_9546C9D2)
References: <1458647539-17213-1-git-send-email-rmanohar@qti.qualcomm.com>
	<1458647539-17213-2-git-send-email-rmanohar@qti.qualcomm.com>,<8760wcdnws.fsf@kamboji.qca.qualcomm.com>,<1458834773112.89396@qti.qualcomm.com>
In-Reply-To: <1458834773112.89396@qti.qualcomm.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[...]
>>
>> I see two new warnings on the kfifo_put() call:
>>
>> drivers/net/wireless/ath/ath10k/htt_rx.c:1722:22: warning: cast to non-scalar
>> drivers/net/wireless/ath/ath10k/htt_rx.c:1722:22: warning: cast from non-scalar
>>
>> But I suspect they are false warnings due to my old compiler:
>>
>> gcc (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3
>>
>> Opinions?
>>
> Hmm... I am not sure why older compiler is not complaining this. Unfortunately
> both x86 and cross compiler are not throwing any warnings though :(
>

older/latest/g