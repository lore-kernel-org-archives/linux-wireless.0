Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:33808 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbaAVJld convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 04:41:33 -0500
Received: by mail-ee0-f53.google.com with SMTP id t10so4661230eei.26
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jan 2014 01:41:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390381747.4189.5.camel@porter.coelho.fi>
References: <1390228033-19162-1-git-send-email-michal.kazior@tieto.com>
	<1390228033-19162-3-git-send-email-michal.kazior@tieto.com>
	<1390318236.6199.45.camel@jlt4.sipsolutions.net>
	<CA+BoTQ==WJPJV=t8=_CZAD5qyW3igAtaOcUz9hNCcvUPYH+jdA@mail.gmail.com>
	<1390381261.4334.12.camel@jlt4.sipsolutions.net>
	<1390381747.4189.5.camel@porter.coelho.fi>
Date: Wed, 22 Jan 2014 10:41:31 +0100
Message-ID: <CA+BoTQncTnvu9TS4mg83bmtAxH1bH1KWWsiGg+hWkQha3BWEmw@mail.gmail.com> (sfid-20140122_104139_157685_66D43BEA)
Subject: Re: [PATCH 2/2] mac80211: implement multi-interface CSA
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 January 2014 10:09, Luca Coelho <luca@coelho.fi> wrote:
> On Wed, 2014-01-22 at 10:01 +0100, Johannes Berg wrote:
>> On Wed, 2014-01-22 at 09:54 +0100, Michal Kazior wrote:
>> > > I'd say Luca's approach has more future, as it makes channel context
>> > > support native. With this, I don't even see how you *could* later add
>> > > real channel context support. A function like this, that essentially
>> > > assumes exactly a single chanctx that might be doing CSA and similar
>> > > seems to make that rather difficult.
>> >
>> > I'm not really aware of Luca's work.
>>
>> I guess he should post it :)
>
> Yes, I have an internal patch that I wrote last year as a proof of
> concept.  I have cut some corners (eg. the non-chanctx case Johannes
> mentioned), so I need to rework it a bit before posting here.
>
>
>> > > In any case, unless I'm missing some bigger picture this seems like a
>> > > really hacky way to add things, basically ignoring all the channel
>> > > context work. Since I care more about channel contexts, maybe we should
>> > > merge support for channel context CSA before we try to do the multi
>> > > thing.
>> >
>> > This is, I assume, Luca's work you're talking about here again. What's
>> > the progress on this? Any time estimates?
>>
>> I think he has patches but they break the non-chanctx case right now...
>
> I'll post the patch (as an early RFC) and explain the concept as soon as
> I manage to catch up with Michal's patches and all the discussions. ;)

I'm looking forward to it :)


Michał
