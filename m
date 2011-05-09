Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:63418 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678Ab1EIK3U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 06:29:20 -0400
Subject: Re: wireless-regdb US and CA settings incorrect?
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: "ext Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Michael Green <Michael.Green@atheros.com>,
	"ext John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
In-Reply-To: <BANLkTimGs+hAX=5wE7PiTuVzD=4iLShBHQ@mail.gmail.com>
References: <1304594478.3749.61.camel@wimaxnb>
	 <BANLkTimGs+hAX=5wE7PiTuVzD=4iLShBHQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 13:28:59 +0300
Message-ID: <1304936939.3749.115.camel@wimaxnb> (sfid-20110509_122924_183130_617924FB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-05-05 at 08:57 -0700, ext Luis R. Rodriguez wrote:
> On Thu, May 5, 2011 at 4:21 AM, Juuso Oikarinen
> <juuso.oikarinen@nokia.com> wrote:
> > Hi John, all,
> >
> > The following is an excerpt of the db.txt from most recent
> > wireless-regdb.
> >
> > country US:
> >         (2402 - 2472 @ 40), (3, 27)
> >         (5170 - 5250 @ 40), (3, 17)
> >         (5250 - 5330 @ 40), (3, 20), DFS
> >         (5490 - 5600 @ 40), (3, 20), DFS
> >         (5650 - 5710 @ 40), (3, 20), DFS
> >         (5735 - 5835 @ 40), (3, 30)
> >
> > country CA:
> >         (2402 - 2472 @ 40), (3, 27)
> >         (5170 - 5250 @ 40), (3, 17)
> >         (5250 - 5330 @ 40), (3, 20), DFS
> >         (5490 - 5710 @ 40), (3, 20), DFS
> >         (5735 - 5835 @ 40), (3, 30)
> >
> > We are under the understanding that the Canadian national rules deny the
> > usage of the 5490-5710 range of frequencies (ref from RSS-210), but the
> > range is present in the allowed range of frequencies for the CA region:
> >
> > "Additional requirements for the band 5600-5650 MHz: Until further
> > notice, devices subject to this Section shall not be capable of
> > transmitting in the band 5600-5650 MHz, so that Environment Canada
> > weather radars operating in this band are protected."
> >
> > Then again, the FCC rules (15.407) do not prohibit the mentioned range
> > of frequencies within the US (with DFS and limited power level) but in
> > the regulatory database that range is missing.
> >
> >
> > Is there a bug in the regulatory db, or am I misunderstanding something?
> 
> 
> Michael, any opinion on this?

Any take on this one?

-Juuso


