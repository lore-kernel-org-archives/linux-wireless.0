Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19311 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934218Ab1JEJz7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:55:59 -0400
Message-ID: <4E8C297C.4000103@qca.qualcomm.com> (sfid-20111005_115603_770377_FD0D987E)
Date: Wed, 5 Oct 2011 12:55:08 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Sangwook Lee <sangwook.lee@linaro.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: Question: ath6kl (driver/net/wireless/ath/ath6kl) with debug_mask
 value
References: <CADPsn1bsUJqcuwZrW+e92aGms+t+TKRasnGb=ujzzgvz+S1Maw@mail.gmail.com>	<4E68ECE2.7060504@qca.qualcomm.com>	<CADPsn1Yvdw58AYXFNPc4L1M1tyJ7K6kEA2j85gRCq+vqAYQu_w@mail.gmail.com>	<CADPsn1Zi20JHmc7EOFCvjDmKWKtHnBCcyxTxWwBK8_vLps_u_w@mail.gmail.com> <CADPsn1ZB_Po5TumMA5r5WewUHC=M+3JUpzt0SyRdc+RG5WeU+g@mail.gmail.com>
In-Reply-To: <CADPsn1ZB_Po5TumMA5r5WewUHC=M+3JUpzt0SyRdc+RG5WeU+g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/04/2011 04:22 PM, Sangwook Lee wrote:
> Hi Kalle

Hi Sangwook,

> I used  git://github.com/kvalo/ath6kl.git for-linville (Sat Oct 1
> 09:43:09 2011 +0300)
> to run AR6003 HW2.0 (hw 2.0 fw 3.1.1.149) in my ARM board.
> 
> But I faced booting problem as like the following:
> Is there any changes for AR6003 HW2.0 with the latest ath6kl git ?

We don't actively test hw 2.0 anymore, actually I'm not even sure
anymore if I have hw2.0 anywhere. If I find the time and a hw2.0 card,
I'll try to debug this.

Kalle
