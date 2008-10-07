Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:61609 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbYJGODe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 10:03:34 -0400
Received: by fk-out-0910.google.com with SMTP id 18so2806286fkq.5
        for <linux-wireless@vger.kernel.org>; Tue, 07 Oct 2008 07:03:33 -0700 (PDT)
Message-ID: <1ba2fa240810070703j471faa30mce3678febf3c20e8@mail.gmail.com> (sfid-20081007_160339_125262_38DB63FE)
Date: Tue, 7 Oct 2008 16:03:32 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] iwlwifi: get rid of IWL_{GET,SET}_BITS crap
Cc: "Christoph Hellwig" <hch@infradead.org>,
	"Holger Schurig" <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <20081007131615.GR3448@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1223311803.15196.36.camel@johannes.berg>
	 <1ba2fa240810061135t24f2dfbv2a5eb0cd5d9e8cd7@mail.gmail.com>
	 <200810070821.56462.hs4233@mail.mn-solutions.de>
	 <20081007071529.GA5010@infradead.org>
	 <20081007131615.GR3448@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 7, 2008 at 3:16 PM, John W. Linville <linville@tuxdriver.com> wrote:
> On Tue, Oct 07, 2008 at 03:15:29AM -0400, Christoph Hellwig wrote:
>> On Tue, Oct 07, 2008 at 08:21:56AM +0200, Holger Schurig wrote:
>> > > I don't want these macros eithers but I NACK any patches with
>> > > cursing in the commit logs.
>> >
>> > I fully agree. There's no need to speak about "crap" when
>> > changing other people's code. In some cultures thats quite
>> > insulting.
>>
>> Well, it is crap.  Looks at it objectively.  It's a perfectly fine
>> description and most of us use it perfectly happily for our own code,
>> too.
>
> I agree that this is at worst a little bit rude.  The patch should be
> rejected or merged on its own basis, although I do reserve the right
> to edit a changelog from time to time... :-)

Appreciated.

> Now, can we discuss the patch rather than Johannes' intemperate
> word choice?

With Johannes permissions I will split the patch into chunks first so
I can take smaller steps second
it will better fit into patches I have in pipe.

Thanks
Tomas
