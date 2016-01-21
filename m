Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:16239 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965052AbcAULqP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 06:46:15 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rob Herring <robh@kernel.org>
CC: Raja Mani <rmani@qti.qualcomm.com>, <devicetree@vger.kernel.org>,
	<linux-arm-msm@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <ath10k@lists.infradead.org>,
	<agross@codeaurora.org>
Subject: Re: [PATCH v3] dt: bindings: add bindings for ipq4019 wifi block
References: <1452664604-8014-1-git-send-email-rmani@qti.qualcomm.com>
	<20160115022021.GA27099@rob-hp-laptop>
Date: Thu, 21 Jan 2016 13:46:02 +0200
In-Reply-To: <20160115022021.GA27099@rob-hp-laptop> (Rob Herring's message of
	"Thu, 14 Jan 2016 20:20:21 -0600")
Message-ID: <87y4bjyx39.fsf@kamboji.qca.qualcomm.com> (sfid-20160121_124633_806219_E95C803B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rob Herring <robh@kernel.org> writes:

> On Wed, Jan 13, 2016 at 11:26:44AM +0530, Raja Mani wrote:
>> Add device tree binding documentation details for wifi block present
>> in Qualcomm IPQ4019 SoC into "qcom,ath10k.txt".
>> 
>> Right now, ath10k wireless driver has support for PCI based wlan devices.
>> There is a plan to extend ath10k driver to support wifi devices which are
>> connected over AHB as well (enumeration will happen via device tree node).
>> For AHB based devices (ie, ipq4019), all wifi properties are supplied via
>> device tree (including irq, reg addr, cal data,etc).
>> 
>> Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
>> ---
>> v3 changes:
>>   - Removed core-id - [Rob]
>>   - Documented which compatible string corresponds to pci devices
>>     and which corresponds to ahb devices. - [Rob]
>> 
>> v2 changes:
>>  - Improved "core-id" description - [Rob]
>>  - Removed "status" documentation - [Rob]
>>  - Added description which properties are applicable
>>    for ahb and which are applicable for pci devices - [Rob]
>>  - Improved commit msg to explain the context.
>>  - Renamed "qca,msi_addr" to "qcom,msi_addr" and
>>    "qca,msi_base" to "qcom,msi_base" to follow uniformity.
>> 
>>  .../bindings/net/wireless/qcom,ath10k.txt          | 89 ++++++++++++++++++++--
>>  1 file changed, 84 insertions(+), 5 deletions(-)
>
> A few typos, otherwise:
>
> Acked-by: Rob Herring <robh@kernel.org>

Rob, thank you for the review. I fixed the typos in ath.git pending
branch and will properly apply this in few days.

-- 
Kalle Valo
