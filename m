Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:51186 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476AbZKQSF6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 13:05:58 -0500
Received: by iwn8 with SMTP id 8so207530iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 17 Nov 2009 10:06:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <C32E4D5CD18647DE9A4F47C6EB1A94C2@qlaptop2>
References: <2205.95.222.251.107.1258282369.squirrel@webmail.otaku42.de>
	<43e72e890911161701p61d0db5ag25a1459f900b3ab7@mail.gmail.com>
	<1803.194.45.26.221.1258473872.squirrel@webmail.madwifi-project.org>
	<43e72e890911170838g26172725ga4a843dc5292c29f@mail.gmail.com>
	<C32E4D5CD18647DE9A4F47C6EB1A94C2@qlaptop2>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 17 Nov 2009 10:05:43 -0800
Message-ID: <43e72e890911171005y1d06e4aan4c5fd35db03dc66b@mail.gmail.com>
Subject: Re: [Madwifi-devel] Survey: What are you using MadWifi for, and why?
To: Tom Sharples <tsharples@qorvus.com>
Cc: Michael Renzmann <mrenzmann@madwifi-project.org>,
	madwifi-users@lists.sourceforge.net,
	linux-wireless <linux-wireless@vger.kernel.org>,
	madwifi-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 17, 2009 at 9:51 AM, Tom Sharples <tsharples@qorvus.com> wrote:
> Comments inline:
>>
>> My point was that there are already hundreds of users already on ath5k
>> and ath9k and that obviously you will get a biased view of MadWifi /
>> ath5k situation (I don't consider MadWifi any type of alternative to
>> ath9k).
>
> We have way more users than this running just our version. There are
> probably tens of thousands of "users" (embedded systems) that run some
> flavor of madwifi.

Haha are you really trying to out count modern Linux kernel users with
MadWifi embedded users?

>>> The development of any software should happen with the user's needs and
>>> requirements in mind
>>
>> Note I didn't say otherwise.
>
> Your comments, at best, give short shrift to the many, many embedded users,
> esp those who run the 2.4.x kernel. Does anyone actually think it would be
> practical to remotely upgrade tens of thousands of unattended devices, some
> of which are miles away from the nearest human, to a 2.6 kernel?

What do you expect to get out of MadWifi at this point if not just
maintenance mode support for that box you cannot even upgrade a full
kernel on that is miles away from any human being?

> Even if
> only 5% fail to come back online, it would be a logistical and
> customer-relations disaster. These aren't windows desktops where someone can
> just curse and then powercycle.

You can perfectly stick to what you have, like I said no one is
forcing you to do anything different, but failing to understand that
MadWifi development has come to a stand still maintenance mode would
be just as ludicrous as expecting you to upgrade every single box you
have out there.

>> Well to me they are clear and I don't need a survey to understand
>> this. ath5k currently lacks:
>>
>>  * DFS
>>  * Multi-BSS AP functionality
>>  * Roaming
>>  * ANI
>>
> You also need to add to this list:
>
> * Fast-frames
> * Compression

Not sure if the above are vendor extensions, if so and if they require
some tweaking on mac8021 chances are you won't get them upstream.

> * Half / quarter channels (hopefully done in a sensible fashion like AirOS
> without the countrycode / regdomain BS)

As far as its supported by IEEE this seems reasonable, you just need
motivated developers.

> We need to aknowledge that "user" includes not just those surfing on their
> laptops, but the far larger number of embedded devices running madwifi each
> and every day, in critical systems, with excellent reliability.

Sure, but just as with MadWifi if you don't have embedded interested
developers on MadWifi you won't get them on ath5k. What should also be
realized though is that not every single knob and feature of MadWifi
will make it upstream. Anything vendor specific or hackish will simply
not make it up -- unless you really have a motivated developer willing
to support it.

  Luis
