Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58624 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751865AbeDQE1g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Apr 2018 00:27:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 17 Apr 2018 09:57:35 +0530
From: govinds@codeaurora.org
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH v2 13/13] dt: bindings: add bindings for wcn3990 wifi
 block
In-Reply-To: <878t9np561.fsf@kamboji.qca.qualcomm.com>
References: <1523378986-11551-1-git-send-email-govinds@codeaurora.org>
 <20180413215340.vhvlhlaapt5uuo7d@rob-hp-laptop>
 <878t9np561.fsf@kamboji.qca.qualcomm.com>
Message-ID: <2807e56b227f483ac343c0e4d098aebe@codeaurora.org> (sfid-20180417_062740_196868_811777B9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 2018-04-16 20:30, Kalle Valo wrote:
> Rob Herring <robh@kernel.org> writes:
> 
>> On Tue, Apr 10, 2018 at 10:19:46PM +0530, Govind Singh wrote:
>>> Add device tree binding documentation details for wcn3990
>>> wifi block present in Qualcomm SDM845/APQ8098 SoC into
>>> "qcom,ath10k.txt".
>>> 
>>> Signed-off-by: Govind Singh <govinds@codeaurora.org>
>>> ---
>>>  .../bindings/net/wireless/qcom,ath10k.txt          | 31 
>>> ++++++++++++++++++++++
>>>  1 file changed, 31 insertions(+)
>> 
>> One nit, otherwise:
>> 
>> Reviewed-by: Rob Herring <robh@kernel.org>
>> 
> 
> [...]
> 
>>> @@ -119,3 +126,27 @@ wifi0: wifi@a000000 {
>>>  	qcom,msi_base = <0x40>;
>>>  	qcom,ath10k-pre-calibration-data = [ 01 02 03 ... ];
>>>  };
>>> +
>>> +Example (to supply wcn3990 SoC wifi block details):
>>> +
>>> +qcom,wifi@18000000 {
>> 
>> wifi@...
> 
> I added this and Rob's Reviewed-by to the patch in the pending branch:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=20f4accbe76af8f137b4218ce4973bda6fc3d23e
> 
> Govind, please check that it's ok.

Looks good to me.

Thanks,
Govind
