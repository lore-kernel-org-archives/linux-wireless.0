Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm.newmedia-net.de ([217.113.179.122]:33579 "EHLO
	webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbaLWTwI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 14:52:08 -0500
Message-ID: <5499C7ED.2020404@dd-wrt.com> (sfid-20141223_205212_313170_1F09BE96)
Date: Tue, 23 Dec 2014 20:52:13 +0100
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
References: <20141217101755.15964.2625.stgit@potku.adurom.net>	<20141217102226.15964.32919.stgit@potku.adurom.net>	<5491D20F.2020202@dd-wrt.com> <87tx0mcled.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87tx0mcled.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Subject: Re: [PATCH v2 8/8] ath10k: add thermal sensor device support
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 23.12.2014 um 18:43 schrieb Kalle Valo:
> Sebastian Gottschall <s.gottschall@dd-wrt.com> writes:
>
>> the whole code will not work. the firmware 10.2.4 returns op_version 3
>> so this check here fails
>>
>> if (ar->wmi.op_version != ATH10K_FW_WMI_OP_VERSION_10_2_4)
>>
>> since 5 is required
> I know, I used firmware-4.bin_10.2.4.13-2 to test this. I just didn't
> have a chance to upload it until now:
>
> https://github.com/kvalo/ath10k-firmware/tree/master/10.2.4
:-) thanks
i tested it using a hardcoded api version patch based on the firmware 
version  and it worked as well so far. (just tested temperture sensor 
readout)

Sebastian

