Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48106 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab1HVV5S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 17:57:18 -0400
Received: by wyg24 with SMTP id 24so3796489wyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Aug 2011 14:57:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110822183432.GI2534@tuxdriver.com>
References: <1312933511-9486-1-git-send-email-thomas@cozybit.com>
	<1313117641-27351-1-git-send-email-thomas@cozybit.com>
	<1313152101.4022.3.camel@jlt3.sipsolutions.net>
	<CAG6hwVN+D+XXAR9B8ZAb2hf_OFKwE875tm=OAS7iytx32uU9MA@mail.gmail.com>
	<20110822183432.GI2534@tuxdriver.com>
Date: Mon, 22 Aug 2011 14:57:10 -0700
Message-ID: <CAG6hwVMdRwyOnHvBQWdKm4eZ4cm1u_6joqf=TejeBGqVfOTCnQ@mail.gmail.com> (sfid-20110822_235722_346126_4168746B)
Subject: Re: [PATCH v2 1/8] mac80211: improve mpath debugging
From: Thomas Pedersen <thomas@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Javier Cardona <javier@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 22, 2011 at 11:34 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Fri, Aug 12, 2011 at 11:12:08AM -0700, Thomas Pedersen wrote:
>> On Fri, Aug 12, 2011 at 5:28 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>
>> > Definitely want the format attribute, that was my whole point :)
>>
>> Oh I see. Looking at it again, my function above doesn't even have any
>> argument checking :P. Didn't know about that __attribute__ etiher,
>> thanks!
>>
>> > Bah, maybe it all doesn't matter, in which case maybe the first version
>> > is better.
>>
>> Sure, let's go with the first one.
>
> OK, I'm confused -- do we want to merge the versions posted on
> 9 August?  Or the ones from 11 August?  Or...?
>

I was referring to the patch from 9 August (v1).

Thomas
> John
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
>
