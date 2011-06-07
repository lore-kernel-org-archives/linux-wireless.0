Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3519 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932269Ab1FGWY0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2011 18:24:26 -0400
Message-ID: <4DEEA506.4070309@broadcom.com> (sfid-20110608_002430_280742_052D33C1)
Date: Tue, 7 Jun 2011 15:24:06 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "Viral Mehta" <Viral.Mehta@lntinfotech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: bcm4329 background scanning
References: <D69C90565D53114396BF743585AF5A0912A8674CC4@VSHINMSMBX01.vshodc.lntinfotech.com>
 <BANLkTikMW7H=NYqX0N-TbhpBd61SSK9ayA@mail.gmail.com>
In-Reply-To: <BANLkTikMW7H=NYqX0N-TbhpBd61SSK9ayA@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/07/2011 02:51 PM, Rafał Miłecki wrote:
> 2011/6/7 Viral Mehta<Viral.Mehta@lntinfotech.com>:
>> I was looking at bcm4329 driver to understand how scanning is happening ?
>>
>> I have two questions,
>> 1. Does bcm4329 supports background scanning ?
>>
>> from looking at the code, it looks like NO
>
> I think bcm4329 barely maintained and noone really work on it.
>
> Did you think about switching to brcmfmac? It receives some love from
> Broadcom and it's more probably you will get some help with this one.
>


bcm4329 is supported and maintained.  brcmfmac came from the same 
codebase, and can be considered the evolution of bcm4329 for longer-term 
usage (eventually ...)

bcm4329 questions should probably go to the appropriate android list vs. 
linux-wireless, but I'll forward them and see if I can get some answers.

- Henry



