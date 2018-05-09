Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45646 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932115AbeEIDuP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 May 2018 23:50:15 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 09 May 2018 09:20:14 +0530
From: Govind Singh <govinds@codeaurora.org>
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Andy Gross <andy.gross@linaro.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 06/12] firmware: qcom: scm: Add WLAN VMID for Qualcomm SCM
 interface
In-Reply-To: <20180507204236.GI2259@tuxbook-pro>
References: <1522042819-25916-1-git-send-email-govinds@codeaurora.org>
 <20180507204236.GI2259@tuxbook-pro>
Message-ID: <55ee4bf22e6557a37cbd46691816bef5@codeaurora.org> (sfid-20180509_055018_809819_A38FC813)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-05-08 02:12, Bjorn Andersson wrote:
> On Sun 25 Mar 22:40 PDT 2018, Govind Singh wrote:
> 
>> Add WLAN related VMID's to support wlan driver to set up
>> the remote's permissions call via TrustZone.
>> 
>> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> 
> Please use ./scripts/get_maintainer.pl for each patch to get a hint
> about whom to send your patches to.
> 
> While I think it's okay that Kalle picks it through his tree Andy 
> should
> give his ack first.
> 
> 
> Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> 
> Regards,
> Bjorn
> 

Thanks Bjorn for the review.
I will take care this point while sending the next version of the qmi 
patch set.

>> ---
>>  include/linux/qcom_scm.h | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>> 
>> diff --git a/include/linux/qcom_scm.h b/include/linux/qcom_scm.h
>> index b401b96..da63d84 100644
>> --- a/include/linux/qcom_scm.h
>> +++ b/include/linux/qcom_scm.h
>> @@ -1,4 +1,4 @@
>> -/* Copyright (c) 2010-2015, The Linux Foundation. All rights 
>> reserved.
>> +/* Copyright (c) 2010-2015, 2018, The Linux Foundation. All rights 
>> reserved.
>>   * Copyright (C) 2015 Linaro Ltd.
>>   *
>>   * This program is free software; you can redistribute it and/or 
>> modify
>> @@ -33,6 +33,8 @@ struct qcom_scm_vmperm {
>> 
>>  #define QCOM_SCM_VMID_HLOS       0x3
>>  #define QCOM_SCM_VMID_MSS_MSA    0xF
>> +#define QCOM_SCM_VMID_WLAN       0x18
>> +#define QCOM_SCM_VMID_WLAN_CE    0x19
>>  #define QCOM_SCM_PERM_READ       0x4
>>  #define QCOM_SCM_PERM_WRITE      0x2
>>  #define QCOM_SCM_PERM_EXEC       0x1
>> --
>> 1.9.1
>> 
