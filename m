Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:28838 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbYJIQfh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 12:35:37 -0400
Received: by fg-out-1718.google.com with SMTP id 19so67292fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 09 Oct 2008 09:35:35 -0700 (PDT)
Message-ID: <1ba2fa240810090935w619f726cm6f8eae9ec1aa05f7@mail.gmail.com> (sfid-20081009_183540_229990_D3DF8B18)
Date: Thu, 9 Oct 2008 18:35:35 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] iwlwifi: get rid of IWL_{GET,SET}_BITS crap
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Christoph Hellwig" <hch@infradead.org>,
	"Holger Schurig" <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
In-Reply-To: <1223545949.22490.26.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1223311803.15196.36.camel@johannes.berg>
	 <1ba2fa240810071228m52a60861r5558529426b9b487@mail.gmail.com>
	 <1223408085.3618.2.camel@johannes.berg>
	 <1223408342.3618.7.camel@johannes.berg>
	 <1ba2fa240810071306sb282e06h9d29ea2c36f5c3d5@mail.gmail.com>
	 <1223410226.3618.13.camel@johannes.berg>
	 <1ba2fa240810071346n506b8f1clffaebb7f1f72a10f@mail.gmail.com>
	 <1223452923.3618.25.camel@johannes.berg>
	 <1ba2fa240810080538i864b901kc8e6e694004dbade@mail.gmail.com>
	 <1223545949.22490.26.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 9, 2008 at 11:52 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2008-10-08 at 14:38 +0200, Tomas Winkler wrote:
>
>> >> > Also, keep in mind that address 2 is _never_ used at all anyway
>> >
>> >> This is not correct we always use first 2 pointers. First for tx command
>> >> second for the actual packet.
>> >
>> > Ok so you use two.
>>
>> My only point is just to make sure that you understand that __never__
>> is not correct
>
> Right, sorry, I really should have checked.
>
>> > Writing three words in total. I strongly suggest that
>> > you have WAY more trouble in iwlwifi than an imagined performance issue
>> > coming from a corrected and understandable struct layout.
>>
>> You are rally trying breaking into open doors Currently I'm more
>> concern with correctness then performance so I wanted to rise
>> hopefully all issues.
>> I'm testing your layout it's work so far in my home setup. I'm on
>> holidays till EOW so I will be able to give it some more stress in Lab
>> only next week.
>
> Sure, that's fine, I can't really see what can go wrong but testing is
> always good.

Not everything can be seen I hoped you've learned that already.
People tend to only test their code whether it fixes the particular
problem they want to fix not seeing the collateral  bugs they are
creating on the way.
But there hundred of books about the subject.

It just seemed to me that for some reason you preferred
> keeping the pair-layout and complicating the code?

Don't take assumptions, people communication is most flawed protocol.
Tomas

Tomas
