Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:35976 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbZE0ATs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 20:19:48 -0400
Received: by bwz22 with SMTP id 22so4217051bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 26 May 2009 17:19:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1243377395.23825.0.camel@johannes.local>
References: <43e72e890904032115m7548f967m5020481c660c8f13@mail.gmail.com>
	 <3ace41890904041944p6cd60084ub2d05a85373459c3@mail.gmail.com>
	 <3ace41890904062120o78018361x409bb3e20b735b75@mail.gmail.com>
	 <43e72e890904062234m3d572f36t1aa7fefa5f78ae74@mail.gmail.com>
	 <3ace41890904070049tc2ed1baod4399a327505ef09@mail.gmail.com>
	 <20090407160812.GA5758@tesla>
	 <3ace41890905250008q255d15dej45a4f53d9f8c90e4@mail.gmail.com>
	 <20090526163013.GA7072@tesla>
	 <69e28c910905261227o7bbf81c8jbc5014792acb3af8@mail.gmail.com>
	 <1243377395.23825.0.camel@johannes.local>
Date: Wed, 27 May 2009 01:19:49 +0100
Message-ID: <3ace41890905261719k3565da39v360adf1e0ff2d270@mail.gmail.com>
Subject: Re: zd1211 3.0.0.56 "vendor driver" - please help port to zd1211rw
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stephen Chen <Stephen.Chen@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/5/26 Johannes Berg <johannes@sipsolutions.net>:
> On Tue, 2009-05-26 at 21:27 +0200, Gábor Stefanik wrote:
>
>> AFAIK the developers will never accept any AP mode for zd1211 devices,
>> as it has no multicast buffering feature in the hardware. (The vendor
>> driver, as well as the Windows driver implements AP mode with a spec
>> violation to get around the lack of a multicast buffer.)
>> CCing Johannes, he was the one who initially said that.
>
> Pretty much exactly it.

I think what I meant is, what else is needed for AP mode from mac80211
? Or is it 'never'?

Hin-Tak
