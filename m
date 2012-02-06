Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42091 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397Ab2BFQ4V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 11:56:21 -0500
Received: by wics10 with SMTP id s10so4315296wic.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Feb 2012 08:56:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120204142502.GA10858@ubuntu-mba>
References: <20120203222818.GA3749@ubuntu-mba>
	<4F2D0C07.1010704@broadcom.com>
	<20120204142502.GA10858@ubuntu-mba>
Date: Mon, 6 Feb 2012 17:56:20 +0100
Message-ID: <CACna6ryR2xm2EAJaV4vCO8WebR5pXCyFknEMrf8ynVF+HYrxTw@mail.gmail.com> (sfid-20120206_175627_805663_D8CC96D7)
Subject: Re: BCM4331 fails to associate after suspend
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Scott Sanbar <scott.sanbar@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/2/4 Seth Forshee <seth.forshee@canonical.com>:
> On Sat, Feb 04, 2012 at 11:44:23AM +0100, Arend van Spriel wrote:
>> On 02/03/2012 11:28 PM, Seth Forshee wrote:
>> >
>> > I've been looking around a bit in the b43 and bcma drivers, but so far I
>> > haven't found the reason why this happens. Any help would be
>> > appreciated. Let me know if there's additional information I can
>> > provide.
>> >
>>
>> With which kernel version do you see these issues? BCMA suspend/resume
>> code has a fix in 3.3-rc1. So if you are seeing it on a 3.2 kernel,
>> please give it a try.
>
> I've tried 3.3-rc2 and the wirless-testing tree, and the problem still
> exists in both.

I don't have access to suspendable machine with Mini PCIe card, not to
mention BCM4331 which is available for Mac-specific slot only (or
routers as embedded wifi). It may be b43 needs to fix but I'm not
really able to work on that. Plus the whole BCM4331 code is really
tricky, as it comes from RE based on dumps only :(

-- 
Rafał
