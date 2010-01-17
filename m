Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:55398 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab0AQQsg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 11:48:36 -0500
Received: by ewy19 with SMTP id 19so2529933ewy.21
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jan 2010 08:48:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <69e28c911001170844m2dd5beb9j6ebca9292f41f7ce@mail.gmail.com>
References: <op.u6oef6cl9lhzdc@linux-g0th.site>
	 <69e28c911001170837u4ea715ddn4a8e2001f6c1acc3@mail.gmail.com>
	 <201001171741.02945.mb@bu3sch.de>
	 <69e28c911001170844m2dd5beb9j6ebca9292f41f7ce@mail.gmail.com>
Date: Sun, 17 Jan 2010 17:48:34 +0100
Message-ID: <b170af451001170848s27dab1acmac125287dacbb3ae@mail.gmail.com>
Subject: Re: [PATCH 2/7] b43: N-PHY: implement TX PHY cleanup and setup
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/1/17 Gábor Stefanik <netrolller.3d@gmail.com>:
> On Sun, Jan 17, 2010 at 5:41 PM, Michael Buesch <mb@bu3sch.de> wrote:
>> On Sunday 17 January 2010 17:37:29 Gábor Stefanik wrote:
>>> While you are at it, why aren't you programming these table writes?
>>> The table handling functions are AFAIK already in place...
>>
>> Because we like small patches.
>> Please do _not_ increase the patchsize.
>
> They do not increase patch size - table reads/writes are one-line (in
> fact, they are shorter than the placeholder comments in place of
> them).

Well, I just started implementing code without understanding of
tables... and got stick in implementing functions. There are some
"crazy" IDs, offsets and it's not only writing but also some
mysterious table reading... You know, it just sounds scary ;)

I'll have to finally read specs/existing code for tables, understand
it and implement.

-- 
Rafał
