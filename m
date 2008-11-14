Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:12706 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbYKNOfu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 09:35:50 -0500
Received: by qw-out-2122.google.com with SMTP id 3so843459qwe.37
        for <linux-wireless@vger.kernel.org>; Fri, 14 Nov 2008 06:35:48 -0800 (PST)
Message-ID: <69e28c910811140635v2c967406p439779c82866f455@mail.gmail.com> (sfid-20081114_153553_271165_7B2D59AE)
Date: Fri, 14 Nov 2008 15:35:48 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Master mode in iw
Cc: "Kalle Valo" <kalle.valo@nokia.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Mark Ryden" <markryde@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20081114141912.GB3443@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <dac45060811130246n41c9983fx2f06f85946b20c1c@mail.gmail.com>
	 <87ej1f6ggq.fsf@nokia.com>
	 <dac45060811130349k3153fcd6i9e6f35f9df3f52ef@mail.gmail.com>
	 <87wsf74z6f.fsf@nokia.com> <1226578011.5105.8.camel@johannes.berg>
	 <87fxlu4rdx.fsf@nokia.com>
	 <69e28c910811140539p57fa13dej4c13aa0d09c76f95@mail.gmail.com>
	 <20081114141912.GB3443@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 14, 2008 at 3:19 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Fri, Nov 14, 2008 at 02:39:50PM +0100, Stefanik G=E1bor wrote:
>> On Fri, Nov 14, 2008 at 9:56 AM, Kalle Valo <kalle.valo@nokia.com> w=
rote:
>
>> > Actually I was thinking about fullmac hardware which support AP mo=
de.
>> > In theory we might need to support those, but I guess in practise
>> > there hasn't been, nor ever will be, such hardware. I'll just shut=
 up
>> > now :)
>
>> I doubt that any fullmac hardware should have a mac80211-based drive=
r...
>
> cfg80211 !=3D mac80211
>
> --
> John W. Linville                Linux should be at the core
> linville@tuxdriver.com                  of your literate lifestyle.
>

But is cfg80211 supposed to be used for completely-fullmac cards that
do AP in hardware?

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
