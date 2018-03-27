Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45546 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754390AbeC0RGq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 13:06:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 27 Mar 2018 22:36:46 +0530
From: govinds@codeaurora.org
To: Peter Oh <peter.oh@bowerswilkins.com>
Cc: ath10k@lists.infradead.org, bjorn.andersson@linaro.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/12] *** Add support for wifi QMI client driver ***
In-Reply-To: <d8e017b6-8642-919f-8c8c-ca322bed90fd@bowerswilkins.com>
References: <1522042636-25516-1-git-send-email-govinds@codeaurora.org>
 <d8e017b6-8642-919f-8c8c-ca322bed90fd@bowerswilkins.com>
Message-ID: <cf0a9e1b6b0b50dfc0a68ca3f75c685c@codeaurora.org> (sfid-20180327_190746_086545_2DEBD1E9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Peter,

On 2018-03-27 01:51, Peter Oh wrote:
>> Add QMI client driver for Q6 integrated WLAN connectivity subsystem.
> Can you give an example which chipset series is Q6 integrated WLAN ?
> 
> Thanks,
> Peter

SDM845/MSM8998 series is using the same, where WLAN firmware is running 
on Q6 processor.


Thanks,
Govind
