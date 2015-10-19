Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:36834 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbbJSLwg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2015 07:52:36 -0400
Received: by ioll68 with SMTP id l68so26109780iol.3
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2015 04:52:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1445254283.3307.0.camel@sipsolutions.net>
References: <1444855924.3054.9.camel@sipsolutions.net>
	<1444856468.3054.17.camel@sipsolutions.net>
	<CAB3XZEdkpYrLXh1yTJCGA-ZGS0eRuqUhTwnD9WgZaw_g7UvioA@mail.gmail.com>
	<1445254283.3307.0.camel@sipsolutions.net>
Date: Mon, 19 Oct 2015 14:52:36 +0300
Message-ID: <CAB3XZEdwybRaKgjQJknVH=iJ+FcPkuh8fhSXaEM9noWdSz1TjA@mail.gmail.com> (sfid-20151019_135239_889696_B88DC657)
Subject: Re: new regdb file format
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 19, 2015 at 2:31 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2015-10-19 at 14:28 +0300, Eliad Peller wrote:
>
>> while at it - is there any way to indicate exclusion of some
>> channels?
>> e.g. channels 38/42 in US (the current rule is "(5170 - 5250 @ 40)",
>> which doesn't seem to forbid them)
>>
>
> Hm? Why would you want to do that, if you are allowed to use that band?
>
The spec seems to indicate the allowed channel set for each operating
class, and some channels are allowed only in some countries (tables
E-1 vs. E-2 in 802.11-2012 Annex E).

Eliad.
