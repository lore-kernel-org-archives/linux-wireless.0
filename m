Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45284 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388217AbeGWNiA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jul 2018 09:38:00 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 23 Jul 2018 18:06:58 +0530
From: Govind Singh <govinds@codeaurora.org>
To: Rob Herring <robh@kernel.org>
Cc: devicetree@vger.kernel.org, bjorn.andersson@linaro.org,
        david.brown@linaro.org, andy.gross@linaro.org,
        niklas.cassel@linaro.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 3/6] dt: bindings: add bindings for msa memory region
In-Reply-To: <20180711152718.GA18470@rob-hp-laptop>
References: <20180706090043.28363-1-govinds@codeaurora.org>
 <20180711152718.GA18470@rob-hp-laptop>
Message-ID: <5ba59b76dfcc8ba997ce7b0ea880329c@codeaurora.org> (sfid-20180723_143715_568177_1F7F8CED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rob,

On 2018-07-11 20:57, Rob Herring wrote:
> On Fri, Jul 06, 2018 at 02:30:43PM +0530, Govind Singh wrote:
>> Add device tree binding documentation details of msa
>> memory region for ath10k qmi client for SDM845/APQ8098
>> SoC into "qcom,ath10k.txt".
>> 
>> Signed-off-by: Govind Singh <govinds@codeaurora.org>
>> ---
>>  .../bindings/net/wireless/qcom,ath10k.txt           | 13 
>> +++++++++++++
>>  1 file changed, 13 insertions(+)
>> 
>> diff --git 
>> a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt 
>> b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> index 7fd4e8ce4149..87489054aea5 100644
>> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> @@ -57,6 +57,16 @@ Optional properties:
>>  - <supply-name>-supply: handle to the regulator device tree node
>>  			   optional "supply-name" is "vdd-0.8-cx-mx".
>> 
>> += SUBNODES:
>> +wcn3990-wifi node may contain one subnode, named "msa" representing
>> +the fixed msa memory regions used by the wifi firmware running in Q6.
>> +This sub-node must contain:
> 
> Why do you need a sub-node? Just add memory-region property.
> 
Fixed in v4 version.

Thanks,
Govind
