Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46602 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab1BIVfa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 16:35:30 -0500
Received: by qyj19 with SMTP id 19so1778339qyj.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Feb 2011 13:35:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297258590.17400.37.camel@dev.znau.edu.ua>
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
Date: Wed, 9 Feb 2011 22:35:29 +0100
Message-ID: <AANLkTi=v9PM8pQ8qF1XpuMSYAy4=MAO2W8TQU+a3AGQn@mail.gmail.com>
Subject: Re: SSB AI support code
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: George Kashperko <george@znau.edu.ua>,
	Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Switching general discussion to this thread.

W dniu 9 lutego 2011 22:12 użytkownik Michael Büsch <mb@bu3sch.de> napisał:
> On Wed, 2011-02-09 at 21:58 +0100, Rafał Miłecki wrote:
>> I don't know, I've doubts about it :/ That flags are quite messy, mask
>> for them is 0x3FFC0000. Ideally we should shift it by 14 bits, but
>> that would make writing code harder. Maaaaybe... Michael what do you
>> think about this?
>
> I have no idea.
> I already expressed my opinion on all this stuff.
>
> One thing is for certain: If this is merged, George has to
> adopt maintainership.

What about proposed solution? Does it still look ugly for you with
that pointers to functions? It looks quite fine separated, similarly
to b43 and PHYs I think. Separated files and structs with pointers.

George: apart from few simple comparisons on beginning (like detecting
type of device and determining name in switch), do you need any more
(many?) tests in general code? Do you have many "if ssb_sb) {} else
{}"?

-- 
Rafał
