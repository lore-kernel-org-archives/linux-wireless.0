Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:45456 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbZEZT2E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 15:28:04 -0400
Received: by bwz22 with SMTP id 22so4060912bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 26 May 2009 12:28:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090526163013.GA7072@tesla>
References: <43e72e890904032115m7548f967m5020481c660c8f13@mail.gmail.com>
	<3ace41890904041944p6cd60084ub2d05a85373459c3@mail.gmail.com>
	<3ace41890904062120o78018361x409bb3e20b735b75@mail.gmail.com>
	<43e72e890904062234m3d572f36t1aa7fefa5f78ae74@mail.gmail.com>
	<3ace41890904070049tc2ed1baod4399a327505ef09@mail.gmail.com>
	<20090407160812.GA5758@tesla> <3ace41890905250008q255d15dej45a4f53d9f8c90e4@mail.gmail.com>
	<20090526163013.GA7072@tesla>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 26 May 2009 21:27:43 +0200
Message-ID: <69e28c910905261227o7bbf81c8jbc5014792acb3af8@mail.gmail.com>
Subject: Re: zd1211 3.0.0.56 "vendor driver" - please help port to zd1211rw
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Hin-Tak Leung <hintak.leung@gmail.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stephen Chen <Stephen.Chen@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 26, 2009 at 6:30 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Mon, May 25, 2009 at 12:08:05AM -0700, Hin-Tak Leung wrote:
>> This is just a head-up that I have a series of diffs to port the
>> vendor driver forward to current kernels, if anybody wants to have a
>> look, for side-by-side scavenging to the rw driver. (I probably will
>> post them to the sourceforge zd1211-dev list after a little look at
>> that oops)
>
> That's great to hear, feel free to post them to linux-wireless as
> RFC/RFTs.
>
>> BTW, anybody has any idea what else is needed for the rw driver to
>> support AP mode?
>
> Not me.

AFAIK the developers will never accept any AP mode for zd1211 devices,
as it has no multicast buffering feature in the hardware. (The vendor
driver, as well as the Windows driver implements AP mode with a spec
violation to get around the lack of a multicast buffer.)
CCing Johannes, he was the one who initially said that.

>
>  Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
