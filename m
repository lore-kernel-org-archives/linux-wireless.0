Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47469 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355Ab0JKR4x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 13:56:53 -0400
Subject: Re: phyX enumeration conflict
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	rainbow lum <rainbowlum@gmail.com>
In-Reply-To: <4CB34D87.9090100@candelatech.com>
References: <201010082159.59262.chunkeey@googlemail.com>
	 <1286698152.3547.4.camel@jlt3.sipsolutions.net>
	 <1286698604.3547.7.camel@jlt3.sipsolutions.net>
	 <4CB1DE18.9070400@candelatech.com>
	 <1286729035.3547.10.camel@jlt3.sipsolutions.net>
	 <4CB348B0.3050909@candelatech.com>
	 <1286818499.3634.67.camel@jlt3.sipsolutions.net>
	 <4CB34D87.9090100@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Oct 2010 19:56:50 +0200
Message-ID: <1286819810.3634.77.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-11 at 10:46 -0700, Ben Greear wrote:
> On 10/11/2010 10:34 AM, Johannes Berg wrote:
> > On Mon, 2010-10-11 at 10:26 -0700, Ben Greear wrote:
> >
> >> However, the 'phy0' name doesn't change in
> >> /debug/ath5k/[phy-dev]/ link, so it confuses my tools.
> >
> > If it used /debug/ieee80211/[phy-dev]/ then it'd be renamed
> > automatically...
> 
> I need to get at specific info in the driver's debugfs dir, however.

Yeah but you can change the driver to put its own stuff into that
directory, and then it doesn't have to worry about renames (which it
isn't told about anyway)

johannes

