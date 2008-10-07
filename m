Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.188]:57052 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbYJGUI6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 16:08:58 -0400
Received: by fk-out-0910.google.com with SMTP id 18so2943736fkq.5
        for <linux-wireless@vger.kernel.org>; Tue, 07 Oct 2008 13:08:55 -0700 (PDT)
Message-ID: <1ba2fa240810071308o65d15c39r239f5d653d6aaa37@mail.gmail.com> (sfid-20081007_220900_608447_45C46303)
Date: Tue, 7 Oct 2008 22:08:55 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] iwlwifi: get rid of IWL_{GET,SET}_BITS crap
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Christoph Hellwig" <hch@infradead.org>,
	"Holger Schurig" <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1223410003.3618.9.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1223311803.15196.36.camel@johannes.berg>
	 <200810070821.56462.hs4233@mail.mn-solutions.de>
	 <20081007071529.GA5010@infradead.org>
	 <20081007131615.GR3448@tuxdriver.com>
	 <1ba2fa240810070703j471faa30mce3678febf3c20e8@mail.gmail.com>
	 <1223398724.7328.45.camel@johannes.berg>
	 <1ba2fa240810071228m52a60861r5558529426b9b487@mail.gmail.com>
	 <1223408085.3618.2.camel@johannes.berg>
	 <1ba2fa240810071301k185eebf6qbca6841af120e0ea@mail.gmail.com>
	 <1223410003.3618.9.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 7, 2008 at 10:06 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-10-07 at 22:01 +0200, Tomas Winkler wrote:
>> On Tue, Oct 7, 2008 at 9:34 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > On Tue, 2008-10-07 at 21:28 +0200, Tomas Winkler wrote:
>> >
>> >> > And please keep the 10 pairs -> 20 addresses, it's a lot easier to
>> >> > understand :)
>> >
>> >> I don't like on this solution two things one is that it 32 bit
>> >> variables sits on unaligned address
>> >
>> > That doesn't matter at all since it's packed, and the bitwise accesses
>> > you did previously are way less efficient.
>>
>> This is not packet this is shared memory.
>
> ??
> The struct is _packed_, nothing to do with packets.
I'm tired .. :)
