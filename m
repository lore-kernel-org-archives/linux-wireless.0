Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:32559 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbbLKJmo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 04:42:44 -0500
Message-ID: <566A9A91.2090700@broadcom.com> (sfid-20151211_104248_695445_70091068)
Date: Fri, 11 Dec 2015 10:42:41 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Franky Lin <frankyl@broadcom.com>
Subject: Re: [PATCH V2 13/13] brcmfmac: add arp offload ip address table configuration
 support
References: <1449751392-32569-1-git-send-email-arend@broadcom.com>	<1449751392-32569-14-git-send-email-arend@broadcom.com>	<566A9392.6090103@broadcom.com> <87a8ph5o56.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87a8ph5o56.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/11/2015 10:29 AM, Kalle Valo wrote:
> Arend van Spriel <arend@broadcom.com> writes:
>
>> On 12/10/2015 01:43 PM, Arend van Spriel wrote:
>>> From: Franky Lin <frankyl@broadcom.com>
>>>
>>> Obtain ipv4 address through inetaddr notification for ARP offload host
>>> ip table configuration.
>>
>> Turns out this patch has a sparse warning, ie. would not work on
>> big-endian system. We have a fix for that. Should I mark this patch as
>> dropped in patchwork?
>
> Yeah, that's the best way. For example you could use state "Changes
> Requested" and then it automatically gets dropped from my queue.

will do that.

Thanks,
Arend


