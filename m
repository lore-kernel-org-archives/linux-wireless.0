Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:40183 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbYLOXEJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 18:04:09 -0500
Received: by ewy10 with SMTP id 10so3360713ewy.13
        for <linux-wireless@vger.kernel.org>; Mon, 15 Dec 2008 15:04:07 -0800 (PST)
Message-ID: <4946E24E.1020504@gmail.com> (sfid-20081216_000413_440749_1E4DB23B)
Date: Tue, 16 Dec 2008 00:03:42 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
References: <494698AF.4020204@gmail.com> <4946A4C9.7040304@lwfinger.net> <200812152043.21971.chunkeey@web.de> <4946BC0C.3040701@gmail.com>
In-Reply-To: <4946BC0C.3040701@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Artur Skawina wrote:
> Christian Lamparter wrote:
>> On Monday 15 December 2008 19:41:13 Larry Finger wrote:
>>> Artur Skawina wrote:
>>>> I have a sinus 154 data usb adapter, which used to work w/ p54 in 2.6.27:
>>> Can you bisect this problem?
>> Naa I guess its "p54: fix memory management".
>> 872037115977dc07ae05e4b6b769bf8726da4e87
>>
>> so tell us if this patch works.
> 
> Nope, the attached patch did not improve things, as the log below shows.
> I'll try bisecting.

Done:
78e74789bf2dab82f9539cd46e7f7583ff9516c1 is first bad commit
commit 78e74789bf2dab82f9539cd46e7f7583ff9516c1
Author: Christian Lamparter <chunkeey@web.de>
Date:   Wed Oct 15 04:07:16 2008 +0200

    p54: fix memory management

artur 
