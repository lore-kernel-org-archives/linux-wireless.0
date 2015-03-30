Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27874 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbbC3Lqo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 07:46:44 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix HTT op backwards compatibility for QCA6174
References: <20150330111428.22198.36611.stgit@potku.adurom.net>
	<CA+BoTQ=s4M9jt46ta1OKp0vAG6wZvZmbBjPU_kmJYr3F6zuB1A@mail.gmail.com>
Date: Mon, 30 Mar 2015 14:46:35 +0300
In-Reply-To: <CA+BoTQ=s4M9jt46ta1OKp0vAG6wZvZmbBjPU_kmJYr3F6zuB1A@mail.gmail.com>
	(Michal Kazior's message of "Mon, 30 Mar 2015 13:25:56 +0200")
Message-ID: <87lhie6738.fsf@kamboji.qca.qualcomm.com> (sfid-20150330_134647_407641_F8FEC15C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 30 March 2015 at 13:14, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Commit 8348db298496 ("ath10k: add ATH10K_FW_IE_HTT_OP_VERSION") broke QCA6174
>> receive side as the HTT ids from ATH10K_FW_HTT_OP_VERSION_MAIN don't have
>> HTT_TLV_T2H_MSG_TYPE_RX_IN_ORD_PADDR_IND set. Fix this by adding a backwards
>> compatibility code which sets HTT op version if it's not set by the firmare
>
> s/firmare/firmware/

Fixed.

>> image.
>>
>> Fixes: 8348db298496 ("ath10k: add ATH10K_FW_IE_HTT_OP_VERSION")
>> Reported-by: Michal Kazior <michal.kazior@tieto.com>
>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>
> Tested-by: Michal Kazior <michal.kazior@tieto.com>

Thanks! And sorry for this.

-- 
Kalle Valo
