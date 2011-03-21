Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53123 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab1CUPaQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 11:30:16 -0400
Received: by qyg14 with SMTP id 14so5113790qyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 08:30:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <op.vso77ddp3ri7v4@arend-laptop>
References: <20110319214234.GA5152@kroah.com>
	<1300573336.11949.25.camel@maggie>
	<20110319234524.GA7493@kroah.com>
	<op.vsmyhmei3ri7v4@arend-laptop>
	<20110320145421.GA13962@kroah.com>
	<op.vsnd1a1i3ri7v4@arend-laptop>
	<20110320162200.GA17030@kroah.com>
	<op.vsng7q1j3ri7v4@arend-laptop>
	<20110320185216.GD19375@kroah.com>
	<AANLkTimEGR-8zhbMQpcAzYkuZ8fHkhj1bOQrb3rShfsP@mail.gmail.com>
	<20110321140505.GA7321@kroah.com>
	<AANLkTi=1eGo7uvP8Uy32yQezhGJTHYkHpEyX9vF=PujF@mail.gmail.com>
	<op.vso77ddp3ri7v4@arend-laptop>
Date: Mon, 21 Mar 2011 16:30:15 +0100
Message-ID: <AANLkTimaRXjzbYP53uHYfJaiX6Z1iy5Qm14g+w_OiJEs@mail.gmail.com>
Subject: Re: new utility kernel module for detecting cores in newer chipsets
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	John Linville <linville@tuxdriver.com>,
	George Kashperko <george@znau.edu.ua>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/3/21 Arend van Spriel <arend@broadcom.com>:
> On Mon, 21 Mar 2011 15:27:49 +0100, Rafał Miłecki <zajec5@gmail.com> wrote:
>
>> The case is, we discussed ssb/ai driver layout few days ago. George
>> shared idea of layout I agree with, nobody shared any objections. If
>> everything goes fine, we should have nicely modularized driver/project
>> supporting Broadcom's buses.
>
> Hi Rafał,
>
> Does this give us one module supporting both buses or does it provide two
> kernel modules (my preference)? I did ask you and George this question
> earlier but I seem to have missed the response from you or George.

I'm still waiting for George to respond and share his code.


>> In this situation I'm not really interested is simple ai driver
>> stripped from brcm80211. According to me, it would led to harder
>> maintenance and harder implementation of support for such a driver in
>> b43.
>
> I can imagine from b43 perspective the only good implementation would be to
> stick with the current b43<->ssb interface. So what will you do when another
> type of SoC interconnect is introduced. Forcing that in the same API as
> well? If you and George propose a new carefully considered API covering the
> functional capabilities of the current (and possibly future) interconnect
> buses I am all for that.
>
> To summarize this, my main issue (and Michael's, I think) is with the
> dependency being imposed between ai and ssb. Having two completely
> independent modules really makes more sense.

This really depends on new interconnect. If it will be totally
different, I'll vote for totally different driver. In case of SSB and
AI, driver layout is similar, it seems George managed to write sth
nice.

George?

-- 
Rafał
