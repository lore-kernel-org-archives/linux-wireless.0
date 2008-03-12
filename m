Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms4.Sony.CO.JP ([211.125.136.198]:52796 "EHLO ms4.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbYCLCZk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 22:25:40 -0400
Date: Wed, 12 Mar 2008 11:24:42 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] PS3: gelic: ignore scan info from zero SSID beacons
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, cbe-oss-dev@ozlabs.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Stefan Assmann <sassmann@suse.de>,
	Dan Williams <dcbw@redhat.com>
In-Reply-To: <1205252287.6387.54.camel@johannes.berg>
References: <20080311130630.0AF0.40F06B3A@sm.sony.co.jp> <1205252287.6387.54.camel@johannes.berg>
Message-Id: <20080312111858.0B0B.40F06B3A@sm.sony.co.jp> (sfid-20080312_022543_400717_E3072990)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, 11 Mar 2008 17:18:07 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> 
> On Tue, 2008-03-11 at 13:15 +0900, Masakazu Mokuno wrote:
> > Some implementations of the hidden SSID APs emit beacons which have the zero
> > length SSID information element instead of SSID padded by null (\0) characters.
> > If the firmware of the PS3 wireless hardware meets these beacons, it abandons parsing
> > IEs. Thus guest OSes get the invalid scan information for the AP.
> > 
> > To work around this, ignore these scan informations from the list.
> 
> I'm not sure this is a good idea. Is there any way to get at decent
> information from those beacons?

Currently no.

-- 
Masakazu MOKUNO

