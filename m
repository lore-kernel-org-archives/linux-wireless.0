Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36694 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbcHOLwT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2016 07:52:19 -0400
MIME-Version: 1.0
In-Reply-To: <87wpjib8pb.fsf@kamboji.qca.qualcomm.com>
References: <147125403645.9434.8008546579326856373.stgit@devbox>
 <147125405701.9434.12911635695339175773.stgit@devbox> <5bb6e373-e110-b1ac-6f65-fdf2f9f059fc@gmail.com>
 <87wpjib8pb.fsf@kamboji.qca.qualcomm.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Mon, 15 Aug 2016 13:52:17 +0200
Message-ID: <CACna6ryuN_qDrVwAbS5P9mfhjMwv2hNeTqEzTQ=WxvP1V=zHXA@mail.gmail.com> (sfid-20160815_135243_678397_66D1C4A2)
Subject: Re: [BUGFIX PATCH 1/2] brcmfmac: Check rtnl_lock is locked when
 removing interface
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Franky Lin <franky.lin@broadcom.com>,
	Hante Meuleman <hante.meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
	<brcm80211-dev-list.pdl@broadcom.com>,
	Network Development <netdev@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 August 2016 at 12:57, Kalle Valo <kvalo@codeaurora.org> wrote:
> Rafał Miłecki <zajec5@gmail.com> writes:
>
>>> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
>>
>> Fixes: a63b09872c1d ("brcmfmac: delete interface directly in code that sent fw request")
>> Acked-by: Rafał Miłecki <rafal@milecki.pl>
>>
>> Kalle: I'm acking this as bugfix for 4.8 release.
>
> Ok. I'll wait few days for more comments before I apply this.

Sure.


> (I assume you are talking only about patch 1)

Yes, I'll leave mutex vs. spinlock to the experts :)

-- 
Rafał
