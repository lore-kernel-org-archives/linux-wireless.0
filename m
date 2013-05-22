Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35584 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab3EVTAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 May 2013 15:00:13 -0400
Date: Wed, 22 May 2013 14:53:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH 7/7] rt2x00: rt2x00dev: use rt2x00dev->bcn->limit
Message-ID: <20130522185320.GI2113@tuxdriver.com> (sfid-20130522_210018_123186_AB2A877E)
References: <1367421455-18463-1-git-send-email-juhosg@openwrt.org>
 <1367421455-18463-8-git-send-email-juhosg@openwrt.org>
 <CAL1gcdNg8YD9_uecmHjHggW6-M_yF5fis+7PNRhAABihmmMQzQ@mail.gmail.com>
 <5182176B.20707@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <5182176B.20707@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 02, 2013 at 09:36:11AM +0200, Gabor Juhos wrote:
> 2013.05.01. 22:08 keltezéssel, Gertjan van Wingerde írta:
> > On Wed, May 1, 2013 at 5:17 PM, Gabor Juhos <juhosg@openwrt.org> wrote:
> >> The beacon data queue is initialized already,
> >> so fetch the number of the queue entries from
> >> that instead of using the entry_num field of
> >> the data queue descriptor.
> >>
> >> The two values are the same, and the use of the
> >> rt2x00dev->bcn->limit value allows us to get rid
> >> of a superfluous pointer dereference.
> >>
> >> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> > 
> > Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
> 
> John, please ignore the last patch. This depends on other patches which were not
> included in the series. Without those it causes the following warning:

OK, dropped...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
