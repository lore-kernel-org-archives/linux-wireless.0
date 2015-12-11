Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:55709 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbbLKJJg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 04:09:36 -0500
Message-ID: <566A92CC.3070605@broadcom.com> (sfid-20151211_100948_352650_F1A50CA8)
Date: Fri, 11 Dec 2015 10:09:32 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH V2 11/13] brcmfmac: Change error print in debug print
References: <1449751392-32569-1-git-send-email-arend@broadcom.com>	<1449751392-32569-12-git-send-email-arend@broadcom.com> <87mvth5qfw.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87mvth5qfw.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/11/2015 09:40 AM, Kalle Valo wrote:
> Arend van Spriel <arend@broadcom.com> writes:
>
>> From: Hante Meuleman <meuleman@broadcom.com>
>>
>> The pcie suspend and resume routines contain some error prints,
>> which should have been debug prints.
>>
>> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
>> Change-Id: Ibafe5d38301ee8f5e86889259ddeaea4dcae4cee
>> Reviewed-on: http://hnd-swgit.sj.broadcom.com:8080/5581
>> Reviewed-by: brcm80211 ci <brcm80211-ci@broadcom.com>
>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>
> I'll fix this one also.

Thanks, Kalle

I could blame gedit, but that is a bit lame. Sorry for the inconvenience.

Regards,
Arend

