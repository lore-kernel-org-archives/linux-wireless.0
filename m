Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:57963 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbYBLTWA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2008 14:22:00 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] mac80211: give burst time in txop rather than 0.1msec units
Date: Tue, 12 Feb 2008 20:21:20 +0100
Cc: Christian Lamparter <chunkeey@web.de>,
	John Linville <linville@tuxdriver.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1202658578.11481.4.camel@johannes.berg> <200802111952.30964.chunkeey@web.de> <1202815900.8931.1.camel@johannes.berg>
In-Reply-To: <1202815900.8931.1.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200802122021.21211.mb@bu3sch.de> (sfid-20080212_192221_627183_59111D1D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 12 February 2008 12:31:40 Johannes Berg wrote:
> > > +	/*
> > > +	 * FIXME: The default values in the spec (IEEE 802.11
> > > +	 *	  7.3.2.19 Table 37) are 47, 94, 0, 0, why use

Does somebody know the correct place where these values are in
the specs? Section 7.3.2.19 is about "Supported channels IE".

> > > +	 *	  47, 94, 63, 0 here? Also, the default AIFS
> > > +	 *	  values (second parameter) are 2, 2, 3, 7...
> > > +	 */

-- 
Greetings Michael.
