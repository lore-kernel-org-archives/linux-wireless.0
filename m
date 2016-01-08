Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34350 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbcAHIrO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2016 03:47:14 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/6] brcmfmac: extend wowl and cleanup
References: <1451988350-2197-1-git-send-email-arend@broadcom.com>
	<568EEF26.2060401@broadcom.com>
Date: Fri, 08 Jan 2016 10:47:06 +0200
In-Reply-To: <568EEF26.2060401@broadcom.com> (Arend van Spriel's message of
	"Fri, 8 Jan 2016 00:05:10 +0100")
Message-ID: <87bn8wjw51.fsf@kamboji.qca.qualcomm.com> (sfid-20160108_094718_165548_721D9EBD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> On 01/05/2016 11:05 AM, Arend van Spriel wrote:
>> This smallish series contains:
>> * link down fix for IBSS.
>> * support wowl upon net detect.
>> * cleanup timeout definitions.
>>
>> The series are intended for 4.5 kernel and apply to
>> the master branch of wireless-drivers-next repo on top
>> of series posted earlier with Message-ID:
>>
>> <1451724102-21911-1-git-send-email-arend@broadcom.com>
>
> Hi Kalle,
>
> Is this one I send last tuesday going to make it. I did not get any
> remarks on these patches so.. pretty please ;-)

Hehe :) I have to admit that I was about to postpone these to 4.6 but
these are actually so simple so I took them anyway.

-- 
Kalle Valo
