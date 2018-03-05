Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46976 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933135AbeCEKqW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Mar 2018 05:46:22 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 05 Mar 2018 16:16:21 +0530
From: akolli@codeaurora.org
To: Sven Eckelmann <sven@narfation.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Sathishkumar Muruganandam <murugana@codeaurora.org>
Subject: Re: [PATCH 2/2] ath10k: add debugfs support to configure fwtest
 parameters
In-Reply-To: <1974303.3lPsqGCgIZ@bentobox>
References: <1520233148-26050-1-git-send-email-akolli@codeaurora.org>
 <1520233148-26050-3-git-send-email-akolli@codeaurora.org>
 <1974303.3lPsqGCgIZ@bentobox>
Message-ID: <53a3580c002d7af01668f4716aae56bd@codeaurora.org> (sfid-20180305_114625_675887_91142D90)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-03-05 13:12, Sven Eckelmann wrote:
> On Montag, 5. März 2018 12:29:08 CET Anilkumar Kolli wrote:
>> @@ -496,6 +497,8 @@ struct ath10k_debug {
>>         u32 reg_addr;
>>         u32 nf_cal_period;
>>         void *cal_data;
>> +       u32 fw_test_param_id;
>> +       u32 fw_test_param_value;
>>  };
> 
> Why is it necessary to have these two values in ath10k_debug? They seem 
> to be
> used only in the context of ath10k_write_fw_test().
> 
Yes. it is not reused, will remove this.

> Where can we find the documentation of the possible param_id and 
> param_values?
> 
All these parameters are for experimentation purpose.

Thanks,
Anil.
