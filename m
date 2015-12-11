Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60274 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894AbbLKJ3s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 04:29:48 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Franky Lin <frankyl@broadcom.com>
Subject: Re: [PATCH V2 13/13] brcmfmac: add arp offload ip address table configuration support
References: <1449751392-32569-1-git-send-email-arend@broadcom.com>
	<1449751392-32569-14-git-send-email-arend@broadcom.com>
	<566A9392.6090103@broadcom.com>
Date: Fri, 11 Dec 2015 11:29:41 +0200
In-Reply-To: <566A9392.6090103@broadcom.com> (Arend van Spriel's message of
	"Fri, 11 Dec 2015 10:12:50 +0100")
Message-ID: <87a8ph5o56.fsf@kamboji.qca.qualcomm.com> (sfid-20151211_102953_422431_ABAD5089)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> On 12/10/2015 01:43 PM, Arend van Spriel wrote:
>> From: Franky Lin <frankyl@broadcom.com>
>>
>> Obtain ipv4 address through inetaddr notification for ARP offload host
>> ip table configuration.
>
> Turns out this patch has a sparse warning, ie. would not work on
> big-endian system. We have a fix for that. Should I mark this patch as
> dropped in patchwork?

Yeah, that's the best way. For example you could use state "Changes
Requested" and then it automatically gets dropped from my queue.

-- 
Kalle Valo
