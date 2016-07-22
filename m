Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:37800 "EHLO
	mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbcGVLVV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2016 07:21:21 -0400
Received: by mail-it0-f41.google.com with SMTP id f6so43502778ith.0
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jul 2016 04:21:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160722103807.GA15262@localhost>
References: <20160721153948.32171-1-me@bobcopeland.com> <CAGRGNgWHJEFBnak-MCK2htkaeQcZ6dmZ=w96omC99G5Z2UJWFg@mail.gmail.com>
 <20160722103807.GA15262@localhost>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 22 Jul 2016 21:21:01 +1000
Message-ID: <CAGRGNgWHboAR2iK=sB9RO7WJOz4PEQQy8AB2WG_LDF1FMm897A@mail.gmail.com> (sfid-20160722_132128_412023_E59AA268)
Subject: Re: [PATCH] iw: display 5/10 MHz channel widths
To: Bob Copeland <me@bobcopeland.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bob,

On Fri, Jul 22, 2016 at 8:38 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Fri, Jul 22, 2016 at 07:53:35PM +1000, Julian Calaby wrote:
>> Hi Bob,
>
> Hi!
>
>> > --- a/interface.c
>> > +++ b/interface.c
>> > @@ -295,6 +295,10 @@ char *channel_width_name(enum nl80211_chan_width width)
>> >                 return "80+80 MHz";
>> >         case NL80211_CHAN_WIDTH_160:
>> >                 return "160 MHz";
>> > +       case NL80211_CHAN_WIDTH_5:
>> > +               return "5 MHz";
>> > +       case NL80211_CHAN_WIDTH_10:
>> > +               return "10 MHz";
>> >         default:
>> >                 return "unknown";
>> >         }
>>
>> Judging by the previous two entries, it looks like the case statements
>> are sorted, so should these ones therefore be at the top of the list?
>
> These are sorted by NL80211_CHAN_WIDTH_* attribute value, which makes
> a little more sense to me than sorting by the string or numerically by
> width, but sure, I can do it either way.

That's fine by me: I was asking because it looked like you might have
just added them to the bottom.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
