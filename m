Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:33361 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab1IZVXA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 17:23:00 -0400
Subject: Re: iwlagn: "Intel Centrino Advanced-N 6205 AGN" and "AVM
 Fritz!Box (7390)" incompatible
From: wwguy <wey-yi.w.guy@intel.com>
To: Henrik Friedrichsen <hrkfdn@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <CAJTrwG6_ybjD9u2zMi+bY73j6CZoncbmOzk8N2N=8Cd=EWLUcA@mail.gmail.com>
References: <CAJTrwG5M5QtS_jw-WmbSb5_NT+m6JcBD0uHCyUzEYhn94G3rkA@mail.gmail.com>
	 <CAJTrwG47wxJMjxo9_gtwut0w17FS2Qz7BOBPc2XCLo39M7WvSQ@mail.gmail.com>
	 <1317048872.2400.4.camel@wwguy-ubuntu>
	 <CAJTrwG5CQKn9=1=HUDX1L5PsFbGws_zK1DTvot9i=KcMX7SwkQ@mail.gmail.com>
	 <1317049160.1958.8.camel@wwguy-huron>
	 <CAJTrwG5eELbDuGFXU4=3gSunPSkKLFvcpSe6gGE_Wc0s5BXZ+A@mail.gmail.com>
	 <CAJTrwG7tzDHxDha5x8r-GJFK=oUE6Zk5zqpN4z4L2LyAD=DueQ@mail.gmail.com>
	 <1317050380.1958.13.camel@wwguy-huron>
	 <CAJTrwG46qRYvda1vcCZXv0BTUyf26gx2qgpNgOG-bm-BCMpqfg@mail.gmail.com>
	 <1317053131.1958.15.camel@wwguy-huron>
	 <C5A7FB31FD9AEA42B600BDC3C74F8E0017052223@orsmsx511.amr.corp.intel.com>
	 <CAJTrwG5AvbtNRZi54tzAoUDv5X9QLVY3L=-OgHYRtnJ-RMesrQ@mail.gmail.com>
	 <1317062004.1958.18.camel@wwguy-huron>
	 <CAJTrwG57r-B-eT-FODsDW1UgoVcS68zcUWo1mOrdHRdoXtNmCg@mail.gmail.com>
	 <C5A7FB31FD9AEA42B600BDC3C74F8E001705253B@orsmsx511.amr.corp.intel.com>
	 <CAJTrwG5MXfixhnNPOdoA3-DYEeKpC==uv4WvE78ZE5U+A10T7Q@mail.gmail.com>
	 <1317071501.2400.10.camel@wwguy-ubuntu>
	 <CAJTrwG6_ybjD9u2zMi+bY73j6CZoncbmOzk8N2N=8Cd=EWLUcA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Sep 2011 14:17:33 -0700
Message-ID: <1317071853.2400.11.camel@wwguy-ubuntu> (sfid-20110926_232304_527915_D6B11102)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-09-26 at 14:21 -0700, Henrik Friedrichsen wrote:
> Hello Wey,
> 
> On Mon, Sep 26, 2011 at 11:11 PM, wwguy <wey-yi.w.guy@intel.com> wrote:
> > Henrik. what kind of traffic you are running? what I see from the log,
> > there are not many aggregated frames, (what I mean is I do not see a lot
> > of BA in the log) which is very different from what I am test here. also
> > I see the retry ratio is high in the aggregated frame compare to what I
> > have here.
> 
> It's nothing big really. The router is not yet connected to the
> internet, so I am mainly just opening the webpanel of the router or
> ping it.

how about just doing a flood ping to your AP
#sudo ping -f <AP's ip address>

Wey

