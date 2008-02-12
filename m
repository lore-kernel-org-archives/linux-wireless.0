Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:14967 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbYBLT5s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2008 14:57:48 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2953992wah.23
        for <linux-wireless@vger.kernel.org>; Tue, 12 Feb 2008 11:57:46 -0800 (PST)
Message-ID: <1ba2fa240802121157t370c8418v8a24484596ce5bcd@mail.gmail.com> (sfid-20080212_195751_968689_E991F014)
Date: Tue, 12 Feb 2008 21:57:45 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH v2] mac80211: give burst time in txop rather than 0.1msec units
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Christian Lamparter" <chunkeey@web.de>,
	"John Linville" <linville@tuxdriver.com>,
	"Michael Wu" <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200802122021.21211.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1202658578.11481.4.camel@johannes.berg>
	 <200802111952.30964.chunkeey@web.de>
	 <1202815900.8931.1.camel@johannes.berg>
	 <200802122021.21211.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 12, 2008 9:21 PM, Michael Buesch <mb@bu3sch.de> wrote:
> On Tuesday 12 February 2008 12:31:40 Johannes Berg wrote:
> > > > + /*
> > > > +  * FIXME: The default values in the spec (IEEE 802.11
> > > > +  *        7.3.2.19 Table 37) are 47, 94, 0, 0, why use
>
> Does somebody know the correct place where these values are in
> the specs? Section 7.3.2.19 is about "Supported channels IE".
>
>
> > > > +  *        47, 94, 63, 0 here? Also, the default AIFS
> > > > +  *        values (second parameter) are 2, 2, 3, 7...
> > > > +  */
>
>
 7.3.2.29 EDCA Parameter Set element

> Greetings Michael.
>
