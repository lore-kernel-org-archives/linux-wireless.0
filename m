Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58600 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932215AbeEIJf6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 05:35:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 09 May 2018 15:05:57 +0530
From: Govind Singh <govinds@codeaurora.org>
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: Replace bit shifts with the BIT() macro for rx
 desc bits
In-Reply-To: <20180509074042.GA768@gmail.com>
References: <20180509044804.13751-1-govinds@codeaurora.org>
 <20180509074042.GA768@gmail.com>
Message-ID: <57eb66a936cb541e81cb9ba4f48df61b@codeaurora.org> (sfid-20180509_113603_094823_F7DF34BD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-05-09 13:10, Marcus Folkesson wrote:
> Hello Govind,
> 
> On Wed, May 09, 2018 at 10:18:04AM +0530, Govind Singh wrote:
>> Use the BIT() macro from 'linux/bitops.h' to define the rx desc
>> bit flags to have consistency with new definitions.
>> 
>> Signed-off-by: Govind Singh <govinds@codeaurora.org>
>> ---
>>  drivers/net/wireless/ath/ath10k/rx_desc.h | 134 
>> +++++++++++-----------
>>  1 file changed, 67 insertions(+), 67 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/ath/ath10k/rx_desc.h 
>> b/drivers/net/wireless/ath/ath10k/rx_desc.h
>> index 545deb6d7af1..b3d7c6e7ac90 100644
>> --- a/drivers/net/wireless/ath/ath10k/rx_desc.h
>> +++ b/drivers/net/wireless/ath/ath10k/rx_desc.h
> 
> Looks good, but please include linux/bitops.h as well.
> 
> From the documentation [1]:
> 
> If you use a facility then #include the file that defines/declares
>  that facility.  Don't depend on other header files pulling in ones
>  that you use.
> 

Thanks, addressed the comment in v2 patchset.

> 
> [1] Documentation/process/submit-checklist.rst
> 
> 
> Best regards
> Marcus Folkesson
