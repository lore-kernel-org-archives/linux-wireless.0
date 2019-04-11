Return-Path: <SRS0=IMqP=SN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78A13C10F14
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 18:37:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 415D62083E
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 18:37:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfDKShA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Apr 2019 14:37:00 -0400
Received: from nbd.name ([46.4.11.11]:38136 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726595AbfDKSgz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Apr 2019 14:36:55 -0400
Received: from p548c862d.dip0.t-ipconnect.de ([84.140.134.45] helo=[192.168.45.69])
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1hEeZ5-0004Yu-Pb; Thu, 11 Apr 2019 20:36:47 +0200
Subject: Re: [RFC V4 2/2] ath10k: add tx hw 802.11 encapusaltion offloading
 support
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        Srini Kode <skode@qti.qualcomm.com>,
        Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
References: <20190410073514.12794-1-john@phrozen.org>
 <20190410073514.12794-3-john@phrozen.org> <87ef69yizo.fsf@purkki.adurom.net>
From:   John Crispin <john@phrozen.org>
Message-ID: <3ffaff0b-3d5c-1413-3f95-13d8430a62fc@phrozen.org>
Date:   Thu, 11 Apr 2019 20:36:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <87ef69yizo.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 10/04/2019 17:31, Kalle Valo wrote:
> John Crispin <john@phrozen.org> writes:
>
>> From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
>>
>> This patch adds support for ethernet rxtx mode to the driver. The feature
>> is enabled via a new module parameter. If enabled to driver will enable
>> the feature on a per vif basis if all other requirements were met.
>>
>> Testing on a IPQ4019 based hardware shows a increase in TCP throughput
>> of ~20% when the feature is enabled.
>>
>> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
>> Signed-off-by: John Crispin <john@phrozen.org>
> Looks good to me.
>
> BTW, for ath10k patches (patchsets including ath10k patches) please try
> to CC also the ath10k list. Easier to find ath10k patches that way.
>
Hi,

Thanks Kalle, I'll be sending a V5 tomorrow with a small improvement on 
the hw crypto part, that unbreaks wpa3. can I add your Acked-by on the 
ath10k part ?

     John

