Return-path: <netrolller.3d@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1249110702.26584.7.camel@johannes.local>
References: <4A73655D.1020205@candelatech.com> <1249110702.26584.7.camel@johannes.local>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sat, 1 Aug 2009 17:54:49 +0200
Message-ID: <69e28c910908010854g46baa21sa017e9830677aa97@mail.gmail.com>
Subject: Re: wpa_test not used in wpa.c
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ben Greear <greearb@candelatech.com>, linux-wireless@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 1, 2009 at 9:11 AM, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Fri, 2009-07-31 at 14:42 -0700, Ben Greear wrote:
>> It seems to me that in this method (and others), wpa_test is not
>> actually assigned a useful value, but it's still tested in code
>> branches.
>
>>
>> Any idea on how this is supposed to work?
>
> It isn't really. It's some dead code that you can enable manually for
> testing or so. It used to be possible to use a private ioctl or so to
> set it, iirc, but that's long gone. I'd have no objections to just
> removing it.
>
> johannes
>

Also, it doesn't look like this is getting compiled in any build -
AFAIK "txrx" classes are long gone (since 2.6.26 or so)...

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
