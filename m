Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr00076.outbound.protection.outlook.com ([40.107.0.76]:64714
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751978AbeENU4M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 May 2018 16:56:12 -0400
Subject: Re: [PATCH 2/2] ath10k: DFS Host Confirmation
To: Kalle Valo <kvalo@codeaurora.org>
References: <1525110339-25326-1-git-send-email-srirrama@codeaurora.org>
 <1525110339-25326-3-git-send-email-srirrama@codeaurora.org>
 <0c224b54-dd10-576f-944f-2d20d1cb2c46@bowerswilkins.com>
 <87d0ye2t75.fsf@kamboji.qca.qualcomm.com>
 <4c3ae0c5-0b26-3be9-ccad-ea71b325d5ad@bowerswilkins.com>
 <87lgcmqfaz.fsf@kamboji.qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Sriram R <srirrama@codeaurora.org>,
        ath10k@lists.infradead.org
From: Peter Oh <peter.oh@bowerswilkins.com>
Message-ID: <e491e3fe-fc45-570f-a27c-ddaf376a1d25@bowerswilkins.com> (sfid-20180514_225616_852384_DB4A5634)
Date: Mon, 14 May 2018 13:55:56 -0700
MIME-Version: 1.0
In-Reply-To: <87lgcmqfaz.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>> Which regulatory enforcement are you talking to? Are you talking about
>> such "prevent users from changing regulatory domain" or "don't provide
>> a manner to change regulatory domain or channel list" ? If not, can
>> you share the section of document?
> Sorry, I don't have any references about that.
>
This question is for "what the patch is trying to solve" and "to comply 
FCC regulatory rule" is not the right answer. It should be answered by 
"FCC regulatory rule section xx.xx.xx".
So we all can double check if this patch addresses "the root cause of 
the requirement" and "if it's the best approach or not"

Thanks,
Peter
