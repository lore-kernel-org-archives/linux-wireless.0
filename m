Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:34079 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbbJSL7u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2015 07:59:50 -0400
Received: by iow1 with SMTP id 1so186113773iow.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2015 04:59:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1445255633.3307.1.camel@sipsolutions.net>
References: <1444855924.3054.9.camel@sipsolutions.net>
	<1444856468.3054.17.camel@sipsolutions.net>
	<CAB3XZEdkpYrLXh1yTJCGA-ZGS0eRuqUhTwnD9WgZaw_g7UvioA@mail.gmail.com>
	<1445254283.3307.0.camel@sipsolutions.net>
	<CAB3XZEdwybRaKgjQJknVH=iJ+FcPkuh8fhSXaEM9noWdSz1TjA@mail.gmail.com>
	<1445255633.3307.1.camel@sipsolutions.net>
Date: Mon, 19 Oct 2015 14:59:49 +0300
Message-ID: <CAB3XZEd8r0xuJ_Qxp5zC8O5a1mOhahBMqUXEGv1CiqPmNQ5chQ@mail.gmail.com> (sfid-20151019_135953_575791_4C5F4EF6)
Subject: Re: new regdb file format
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 19, 2015 at 2:53 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2015-10-19 at 14:52 +0300, Eliad Peller wrote:
>>
>> > Hm? Why would you want to do that, if you are allowed to use that
>> > band?
>> >
>> The spec seems to indicate the allowed channel set for each operating
>> class, and some channels are allowed only in some countries (tables
>> E-1 vs. E-2 in 802.11-2012 Annex E).
>>
>
> But that's a different problem in a way - the regulatory database only
> tries to encode the legal restrictions, not the spec restrictions.
>
that's a good point :)

thanks,
Eliad.
