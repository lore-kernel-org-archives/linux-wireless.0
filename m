Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:13608 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbZHJURT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 16:17:19 -0400
Received: by fg-out-1718.google.com with SMTP id e21so800316fga.17
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2009 13:17:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090810201431.GA6060@tuxdriver.com>
References: <4A806973.1020109@gmail.com> <4A806C2F.9070206@lwfinger.net>
	<69e28c910908101158nbc9477re66a203657b702f6@mail.gmail.com>
	<20090810201431.GA6060@tuxdriver.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 10 Aug 2009 22:16:58 +0200
Message-ID: <69e28c910908101316m66ea76dfq2108144e916a7544@mail.gmail.com>
Subject: Re: [PATCH] b43: Implement LP-PHY baseband table initialization
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/10 John W. Linville <linville@tuxdriver.com>:
> On Mon, Aug 10, 2009 at 08:58:44PM +0200, Gábor Stefanik wrote:
>> 2009/8/10 Larry Finger <Larry.Finger@lwfinger.net>:
>> > Gábor Stefanik wrote:
>> >> Implement LP-PHY baseband table init for all revisions.
>> >>
>> >> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
>> >> ---
>> >> Changes from RFC:
>> >> -Improved table formatting in the code.
>> >> -The 2GHz check in adjust_gain_table now uses b43_current_band.
>> >> -Added a comment to rev2plus_table_init about a possible future
>> >> improvement.
>> >
>> > I like the new table formatting.
>> >
>> > The comment in rev2plus_table_init has a typo - "ben" should be
>> > "been". Otherwise it looks good. Thanks for all your work.
>> >
>> > Larry
>> >
>>
>> John, can you fix that when checking in, or should I resubmit with the
>> typo fixed?
>
> Sure, fine...
>
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
>
Thanks!


-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
