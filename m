Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:37235 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072AbYBLUm2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2008 15:42:28 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [PATCH v2] mac80211: give burst time in txop rather than 0.1msec units
Date: Tue, 12 Feb 2008 21:42:09 +0100
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Christian Lamparter" <chunkeey@web.de>,
	"John Linville" <linville@tuxdriver.com>,
	"Michael Wu" <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1202658578.11481.4.camel@johannes.berg> <200802122021.21211.mb@bu3sch.de> <1ba2fa240802121157t370c8418v8a24484596ce5bcd@mail.gmail.com>
In-Reply-To: <1ba2fa240802121157t370c8418v8a24484596ce5bcd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802122142.10325.mb@bu3sch.de> (sfid-20080212_204232_004738_557C8294)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 12 February 2008 20:57:45 Tomas Winkler wrote:
> On Feb 12, 2008 9:21 PM, Michael Buesch <mb@bu3sch.de> wrote:
> > On Tuesday 12 February 2008 12:31:40 Johannes Berg wrote:
> > > > > + /*
> > > > > +  * FIXME: The default values in the spec (IEEE 802.11
> > > > > +  *        7.3.2.19 Table 37) are 47, 94, 0, 0, why use
> >
> > Does somebody know the correct place where these values are in
> > the specs? Section 7.3.2.19 is about "Supported channels IE".
> >
> >
> > > > > +  *        47, 94, 63, 0 here? Also, the default AIFS
> > > > > +  *        values (second parameter) are 2, 2, 3, 7...
> > > > > +  */
> >
> >
>  7.3.2.29 EDCA Parameter Set element

Thanks, found it :)


-- 
Greetings Michael.
