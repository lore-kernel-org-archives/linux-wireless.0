Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:34978 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758568AbcEFWnZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2016 18:43:25 -0400
Received: by mail-oi0-f47.google.com with SMTP id x19so154976236oix.2
        for <linux-wireless@vger.kernel.org>; Fri, 06 May 2016 15:43:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6rwrNWzU415zK43fiwBc+BbfosdiSrJk11=pCs7uZDYV=w@mail.gmail.com>
References: <CACna6rzA1JcTjBsozR5nhCH9U9bKwceTNwLzeQ-Ds97NECVaeQ@mail.gmail.com>
	<CACna6rwgOuUtgjduwgQoZPFewZ3Wn2vgXapCvqw1ygbyt3Jqaw@mail.gmail.com>
	<56F1A9E9.5090803@broadcom.com>
	<CACna6ryFGQT56QGxsMF=a5Qi+eDp+3mByoxTQidWrxR6qRpBmA@mail.gmail.com>
	<56F273AB.2060001@broadcom.com>
	<CACna6rwrNWzU415zK43fiwBc+BbfosdiSrJk11=pCs7uZDYV=w@mail.gmail.com>
Date: Sat, 7 May 2016 00:43:23 +0200
Message-ID: <CACna6rxbHHg7CjsSN8yZP4kxCqzxb4QQGhKLR0GsuQe=n47puQ@mail.gmail.com> (sfid-20160507_004421_113362_FCB08ED1)
Subject: Re: Problem with brcmfmac removing extra interface
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 March 2016 at 20:13, Rafał Miłecki <zajec5@gmail.com> wrote:
> On 23 March 2016 at 11:44, Arend Van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>> On 23-3-2016 9:47, Rafał Miłecki wrote:
>>> On 22 March 2016 at 21:24, Arend van Spriel
>>> <arend.vanspriel@broadcom.com> wrote:
>>>> On 22-3-2016 7:36, Rafał Miłecki wrote:
>>>>> Hi, any ideas / help regarding this issue?
>>>>
>>>> Restarting hostapd obviously is a valid scenario. My guess is we would
>>>> need to avoid interface removal in brcmf_notify_connect_status_ap. But
>>>> first I would like to know in which state the firmware is upon
>>>> brcmf_ap_add_vif. Can you provide a full log with FWCON debug level enabled?
>>>
>>> Sure, hope it helps!
>>
>> Ah. Actually would like to see some driver logging as well so
>> 'debug=0x101410'.
>
> Sure, there you go.

Did this allow you to understand this problem any better? Do you have
any idea for a solution?

-- 
Rafał
