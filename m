Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:63300 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbZKNRnT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Nov 2009 12:43:19 -0500
Received: by iwn8 with SMTP id 8so3375686iwn.33
        for <linux-wireless@vger.kernel.org>; Sat, 14 Nov 2009 09:43:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1258159451.4589.3.camel@localhost.localdomain>
References: <1258156563.4589.2.camel@localhost.localdomain>
	<43e72e890911131614v1b5ac6f5xa80caab69f400d4e@mail.gmail.com>
	<1258159451.4589.3.camel@localhost.localdomain>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sat, 14 Nov 2009 09:43:05 -0800
Message-ID: <43e72e890911140943t3a70b9a9g3ab9002b4acb92de@mail.gmail.com>
Subject: Re: Unable to buid mac80211 with pid and minstrel
To: =?UTF-8?Q?Mart=C3=ADn_Ernesto_Barreyro?= <barreyromartin@gmail.com>
Cc: linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 13, 2009 at 4:44 PM, Martín Ernesto Barreyro
<barreyromartin@gmail.com> wrote:
> El vie, 13-11-2009 a las 16:14 -0800, Luis R. Rodriguez escribió:
>> On Fri, Nov 13, 2009 at 3:56 PM, Martín Ernesto Barreyro
>> <barreyromartin@gmail.com> wrote:
>> > Hello I'm trying to build the wireless testing kernel with pid and
>> > minstrel and then select them from one or another.
>> >
>> > Can someone give me a clue?
>>
>> IIRC I had to enable embedded.
>>
>>   Luis
>
> Thanks, now it appears.

Anyone recall why PID is pegged to embedded?

  Luis
