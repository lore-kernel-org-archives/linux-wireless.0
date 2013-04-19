Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:39499 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967965Ab3DSKKD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 06:10:03 -0400
Message-ID: <517117F8.1030009@openwrt.org> (sfid-20130419_121008_859839_23D63D98)
Date: Fri, 19 Apr 2013 12:10:00 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Gertjan van Wingerde <gwingerde@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Subject: Re: [rt2x00-users] [PATCH] rt2x00: rt2800lib: rename rt2800_init_bbb_early
 to rt2800_init_bbp_early
References: <1366359232-31513-1-git-send-email-juhosg@openwrt.org> <CAL1gcdM_AcacVyYTrE0EiY5b3Pw7i3ZXadLGYZOsvJDLrOhdcA@mail.gmail.com>
In-Reply-To: <CAL1gcdM_AcacVyYTrE0EiY5b3Pw7i3ZXadLGYZOsvJDLrOhdcA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013.04.19. 11:32 keltezéssel, Gertjan van Wingerde írta:
> On Fri, Apr 19, 2013 at 10:13 AM, Gabor Juhos <juhosg@openwrt.org> wrote:
>> The function is used for BBP register initialization,
>> fix the typo in the function name to reflect that.
>>
>> The patch contains no functional changes.
>>
>> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> 
> Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

Thanks!

> Thanks Gabor. Interesting that no-one has noticed this thus far.

Probably because the function is quite new. I have noticed the typo accidentally
when I have looked at something else.


-Gabor
