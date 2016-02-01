Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932715AbcBAPCh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 10:02:37 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Rakhi Sharma <rakhish1994@gmail.com>, Larry.Finger@lwfinger.net,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org
Subject: Re: [PATCH 3/3] Staging: rtl8723au: core: rtw_ieee80211: Fixed space and brace coding style issue.
References: <1454246643-24049-1-git-send-email-rakhish1994@gmail.com>
	<wrfjy4b5zuhl.fsf@redhat.com> <1454261145.7329.58.camel@perches.com>
	<wrfjio287gwy.fsf@redhat.com> <1454336901.7329.63.camel@perches.com>
Date: Mon, 01 Feb 2016 10:02:36 -0500
In-Reply-To: <1454336901.7329.63.camel@perches.com> (Joe Perches's message of
	"Mon, 01 Feb 2016 06:28:21 -0800")
Message-ID: <wrfja8nk79tf.fsf@redhat.com> (sfid-20160201_160241_494941_79917F57)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:
> On Mon, 2016-02-01 at 07:29 -0500, Jes Sorensen wrote:
>> Joe Perches <joe@perches.com> writes:
> []
>> > so this could be transformed into something like:
>> > 
>> > int rtw_get_bit_value_from_ieee_value23a(u8 val)
>> > {
>> > 	int i;
>> > 	static const u8 dot11_rate_table[] = {
>> > 		2, 4, 11, 22, 12, 18, 24, 36, 48, 72, 96, 108
>> > 	};
>> 
>> and per my previous email, the above is worse than than the original.
>> The cleaner way to list it would be:
>> 
>> 	static const char dot11_rate_table[] =
>> 		{ 2, 4, 11, 22, 12, 18, 24, 36, 48, 72, 96, 108 };
>
> Either style is OK, but the style I used is slightly
> more common in the kernel overall, about 2:1.

It wastes a line for now reason and having the open bracket on a line by
itself is slightly more obfuscating.

> The type should ideally be u8 and not char.

u8 or char is not a big deal for me here, I'm fine with either.

Jes
