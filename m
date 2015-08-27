Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:59537 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbbH0IEy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2015 04:04:54 -0400
Message-ID: <55DEC4A3.5060001@broadcom.com> (sfid-20150827_100459_861383_00B3D675)
Date: Thu, 27 Aug 2015 10:04:51 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/12] brcmfmac: multiple interface rework and cleanup
References: <1440620104-2715-1-git-send-email-arend@broadcom.com> <87egipxkzi.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87egipxkzi.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/27/2015 09:13 AM, Kalle Valo wrote:
> Arend van Spriel <arend@broadcom.com> writes:
>
>> This patch series contains the following:
>> * rework code dealing with multiple interfaces.
>> * allow logging firmware console using debug level.
>> * fix crash in error path when probe fails.
>> * fix memory leak in free net devices.
>> * minor code cleanup.
>>
>> The patch series is intended for v4.3 and applies to the master
>> branch of the wireless-drivers-next repository.
>
> Most likely the merge window starts on Sunday so I'm not able to send
> these to 4.3 anymore. But if the merge window gets delayed again when
> I'll send this.

Unlikely from what I read in -rc8 announcement, but thanks for the 
incentive ;-)

Regards,
Arend

