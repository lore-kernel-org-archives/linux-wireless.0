Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:28445 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbYKZATo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 19:19:44 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 25 Nov 2008 16:19:44 -0800
Date: Tue, 25 Nov 2008 16:19:42 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Pavel Roskin <proski@gnu.org>
CC: Richard Farina <sidhayn@gmail.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: wireless-regdb: flaw in general functionality
Message-ID: <20081126001942.GN5950@tesla> (sfid-20081126_011948_194794_A597BBB8)
References: <492B2B74.7040404@gmail.com> <20081124231204.GN6245@tesla> <1227568883.28878.15.camel@dv> <43e72e890811241526o1ea6ecf7ge05a2319d6ff3641@mail.gmail.com> <492B623E.5030202@gmail.com> <1227580299.32415.2.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1227580299.32415.2.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 24, 2008 at 06:31:39PM -0800, Pavel Roskin wrote:
> On Mon, 2008-11-24 at 21:26 -0500, Richard Farina wrote:
> 
> > I'm all for adding it to crda as no-transmit but, is that a valid flag?
> > Also, how well does it work?  From a monitor mode interface you can
> > inject raw packets out of the interface.  Would just adding
> > "no-transmit" into the crda line work?  I certainly don't see this in
> > the crda code anywhere, nor in the definition of regdb file.  I presume
> > this has to be added?
> 
> I don't know anything about the process for introducing new CRDA flags.

This is documented here:

http://wireless.kernel.org/en/developers/Regulatory#Changingthedatabasefileformat

  Luis
