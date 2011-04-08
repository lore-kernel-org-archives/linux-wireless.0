Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63563 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757040Ab1DHXQY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 19:16:24 -0400
Received: by qyk7 with SMTP id 7so165889qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Apr 2011 16:16:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=7OZ40Tn-=8KCX_ReNsUQ3euwTfQ@mail.gmail.com>
References: <1302267632-2326-1-git-send-email-zajec5@gmail.com>
	<1302299890.28673.1.camel@maggie>
	<BANLkTi=7OZ40Tn-=8KCX_ReNsUQ3euwTfQ@mail.gmail.com>
Date: Sat, 9 Apr 2011 01:16:24 +0200
Message-ID: <BANLkTi=fbjLbERhsiqiWSJSGcBk1eeA5Yg@mail.gmail.com>
Subject: Re: [PATCH][2.6.39?] b43: trivial: update module info about firmware
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 9 kwietnia 2011 01:16 użytkownik Rafał Miłecki
<zajec5@gmail.com> napisał:
> W dniu 8 kwietnia 2011 23:58 użytkownik Michael Büsch <mb@bu3sch.de> napisał:
>> On Fri, 2011-04-08 at 15:00 +0200, Rafał Miłecki wrote:
>>> We do not use ucode9,
>>
>> Well, but we should.
>> There are only minor differences between r5 and r9 firmware.
>> r9 basically is a r5 firmware with workarounds added that are
>> needed for r9 devices.
>>
>> So I think we should start using r9 instead of removing it here.
>
> I meant to add support for loading ucode 9 later and the re-add info
> about this. But OK, I'll make V2 which only adds 16_mimo. For normal
> development cycle (wireless-testing) I'll add ucode9 loading support.

John: wait for V2 please.

-- 
Rafał
