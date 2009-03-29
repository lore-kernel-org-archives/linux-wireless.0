Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:44187 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbZC2XPh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Mar 2009 19:15:37 -0400
Received: by ewy9 with SMTP id 9so1839996ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 29 Mar 2009 16:15:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <40f31dec0903291613w6b6520a5ucf8daeede7a6ae0@mail.gmail.com>
References: <200903241938.47155.chunkeey@web.de>
	 <b6c5339f0903241159x505fc88ap4d9850fa74733156@mail.gmail.com>
	 <20090324184100.GA29268@tesla>
	 <b6c5339f0903241303y58aca745rfad05ed8ddb93e70@mail.gmail.com>
	 <43e72e890903241310m1c09a55ex4c47aebdb483896e@mail.gmail.com>
	 <1237926664.4320.131.camel@johannes.local>
	 <43e72e890903241504u4dfb5c76kbcb11a096bba72fc@mail.gmail.com>
	 <20090328163929.GA24075@hash.localnet>
	 <40f31dec0903291613w6b6520a5ucf8daeede7a6ae0@mail.gmail.com>
Date: Mon, 30 Mar 2009 02:15:34 +0300
Message-ID: <40f31dec0903291615g73443eccpf2e41efc7460104@mail.gmail.com> (sfid-20090330_011541_850284_AE31998C)
Subject: Re: [RFC] ath9k's regulatory domain code changes (for ar9170)
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Christian Lamparter <chunkeey@web.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/3/30 Nick Kossifidis <mickflemm@gmail.com>:
> 2009/3/28 Bob Copeland <me@bobcopeland.com>:
>> On Tue, Mar 24, 2009 at 03:04:59PM -0700, Luis R. Rodriguez wrote:
>>> >> > Channel list is a good hint, maybe
>>> >> > it's time to fix iw/nl80211 to send back all the channels :)
>>> >
>>> > I looked into yesterday actually, and it's completely non-trivial=
 and
>>> > requires userspace interface changes.
>>>
>>> Heh, there goes that idea then. Then in that case I'd advocate even
>>> more trimming the channels down.
>>
>> Nick, what do you think of this? =C2=A0I think it's the best comprom=
ise
>> for now - people can still get all the channels, normal users get a
>> nice speedup in the default case.
>>

By the way it would be nice if you could also clean up CHANNEL_DEBUG
stuff from ath5k.h etc ;-)

--=20
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
