Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49476 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751002AbeDPPAn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Apr 2018 11:00:43 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Rob Herring <robh@kernel.org>
Cc: Govind Singh <govinds@codeaurora.org>, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH v2 13/13] dt: bindings: add bindings for wcn3990 wifi block
References: <1523378986-11551-1-git-send-email-govinds@codeaurora.org>
        <20180413215340.vhvlhlaapt5uuo7d@rob-hp-laptop>
Date: Mon, 16 Apr 2018 18:00:38 +0300
In-Reply-To: <20180413215340.vhvlhlaapt5uuo7d@rob-hp-laptop> (Rob Herring's
        message of "Fri, 13 Apr 2018 16:53:40 -0500")
Message-ID: <878t9np561.fsf@kamboji.qca.qualcomm.com> (sfid-20180416_170059_532055_AF637F04)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rob Herring <robh@kernel.org> writes:

> On Tue, Apr 10, 2018 at 10:19:46PM +0530, Govind Singh wrote:
>> Add device tree binding documentation details for wcn3990
>> wifi block present in Qualcomm SDM845/APQ8098 SoC into
>> "qcom,ath10k.txt".
>> 
>> Signed-off-by: Govind Singh <govinds@codeaurora.org>
>> ---
>>  .../bindings/net/wireless/qcom,ath10k.txt          | 31 ++++++++++++++++++++++
>>  1 file changed, 31 insertions(+)
>
> One nit, otherwise:
>
> Reviewed-by: Rob Herring <robh@kernel.org>
>

[...]

>> @@ -119,3 +126,27 @@ wifi0: wifi@a000000 {
>>  	qcom,msi_base = <0x40>;
>>  	qcom,ath10k-pre-calibration-data = [ 01 02 03 ... ];
>>  };
>> +
>> +Example (to supply wcn3990 SoC wifi block details):
>> +
>> +qcom,wifi@18000000 {
>
> wifi@...

I added this and Rob's Reviewed-by to the patch in the pending branch:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=20f4accbe76af8f137b4218ce4973bda6fc3d23e

Govind, please check that it's ok.

-- 
Kalle Valo
