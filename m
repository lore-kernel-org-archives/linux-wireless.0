Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:44496 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbYJDTzT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Oct 2008 15:55:19 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: "Stefanik =?iso-8859-1?q?G=E1bor?=" <netrolller.3d@gmail.com>
Subject: Re: Trendnet TEW-424UB now Realtek 8187B
Date: Sat, 4 Oct 2008 16:55:13 -0300
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Hin-Tak Leung" <hintak.leung@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, keithl@keithl.com,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"Daniel Drake" <dsd@gentoo.org>
References: <20081004011510.GA10015@gate.kl-ic.com> <1223110250.24551.72.camel@johannes.berg> <69e28c910810040607x392a5ddfra8d257b0ff3b9c6e@mail.gmail.com>
In-Reply-To: <69e28c910810040607x392a5ddfra8d257b0ff3b9c6e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200810041655.13816.herton@mandriva.com.br> (sfid-20081004_215526_063338_B98EBBE5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 04 October 2008 10:07:08 Stefanik G=E1bor wrote:
> On Sat, Oct 4, 2008 at 10:50 AM, Johannes Berg
>
> <johannes@sipsolutions.net> wrote:
> > On Sat, 2008-10-04 at 01:47 -0700, Luis R. Rodriguez wrote:
> >> On Sat, Oct 4, 2008 at 1:32 AM, Johannes Berg <johannes@sipsolutio=
ns.net>=20
wrote:
> >> > On Fri, 2008-10-03 at 18:15 -0700, Keith Lofstrom wrote:
> >>
> >> What Realtek driver? Just FYI rtl8187 does *not* claim the RTL8187=
B.
> >> See:
> >>
> >> http://wireless.kernel.org/en/users/Drivers/rtl8187
> >
> > Oh, I thought there was a version now that did.
> >
> > johannes
>
> Hin-Tak Leung added support for RTL8187B a while ago, although it's
> still a bit buggy. Likely someone forgot to update the rtl8187 page o=
n
> the wiki. CCing Hin-Tak and Herton.

I created an account there now and did a minimal update on the page, pl=
ease=20
take a look. There are some things we need to improve in the driver, we=
=20
received also an updated driver and a minimal datasheet but unfortunate=
ly=20
from my part I didn't had much success and time in playing/learning to=20
improve its support.

--
[]'s
Herton
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
