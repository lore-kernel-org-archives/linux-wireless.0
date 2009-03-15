Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:43243 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbZCOUKt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2009 16:10:49 -0400
Message-ID: <49BD609B.4010406@nokia.com> (sfid-20090315_211101_050657_DA225877)
Date: Sun, 15 Mar 2009 22:10:03 +0200
From: Kalle Valo <kalle.valo@nokia.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Subject: Re: [RFC PATCH v2 4/4] mac80211: add beacon filtering support
References: <20090314171234.11126.21125.stgit@tikku>	 <20090314171452.11126.11618.stgit@tikku>	 <43e72e890903141318n25fa5f4bi7903eee2ef216040@mail.gmail.com>	 <87r60z1c8x.fsf@nokia.com> <1237139955.24381.2.camel@johannes.local> <43e72e890903151227q2b1cc5a8vd5dcc0e102fa7350@mail.gmail.com>
In-Reply-To: <43e72e890903151227q2b1cc5a8vd5dcc0e102fa7350@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Sun, Mar 15, 2009 at 10:59 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Sun, 2009-03-15 at 09:22 +0200, Kalle Valo wrote:
>>
>>> I think this is future stuff, I would like to get the basic (and the
>>> simplest) implementation to the tree first and then we can start
>>> improving and extending it.
>> Agreed, anything that is more complex than this basic stuff which
>> requires proper beacon change watching by the firmware is too much for
>> the first cut here -- we're having enough trouble as-is, for example
>> with the BSS struct stuff.
> 
> Understood, can we just add some text to the doc then elaborating what
> is expected of the hardware for now.

Sure thing. I already have a todo item to write a better description.

Kalle
