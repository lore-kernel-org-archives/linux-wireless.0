Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60444 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab1BOAEh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 19:04:37 -0500
Received: by qwa26 with SMTP id 26so3547006qwa.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 16:04:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297727969.5683.21.camel@maggie>
References: <1297725710.5683.17.camel@maggie>
	<AANLkTimjkFJrWpubECRRNybmvYdcAh3UUbMOa0iv166g@mail.gmail.com>
	<1297727969.5683.21.camel@maggie>
Date: Tue, 15 Feb 2011 01:04:36 +0100
Message-ID: <AANLkTikQx_NTMxQ+XpL-3BKWkZMERs_A-aQf0mKBHaSg@mail.gmail.com>
Subject: Re: [PATCH] ssb: Make ssb_wait_bit multi-bit safe
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 15 lutego 2011 00:59 użytkownik Michael Büsch <mb@bu3sch.de> napisał:
> On Tue, 2011-02-15 at 00:44 +0100, Rafał Miłecki wrote:
>> 2011/2/15 Michael Büsch <mb@bu3sch.de>:
>> > ssb_wait_bit was designed for only one-bit bitmasks.
>> > People start using it for multi-bit bitmasks. Make the "set" case
>> > is safe for this. The "unset" case is already safe.
>>
>> Thanks :)
>
> This should not change the behavior of your patch, though,
> as you only add an "unset" case, which was already correct.
>
> So this doesn't fix an actual bug but rather hardens the code
> for future use.

Yes, I can see that :)

-- 
Rafał
