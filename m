Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:40186 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab1IZVRJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 17:17:09 -0400
Subject: Re: iwlagn: "Intel Centrino Advanced-N 6205 AGN" and "AVM
 Fritz!Box (7390)" incompatible
From: wwguy <wey-yi.w.guy@intel.com>
To: Henrik Friedrichsen <hrkfdn@gmail.com>
Cc: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <CAJTrwG5MXfixhnNPOdoA3-DYEeKpC==uv4WvE78ZE5U+A10T7Q@mail.gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Sep 2011 14:11:41 -0700
Message-ID: <1317071501.2400.10.camel@wwguy-ubuntu> (sfid-20110926_231713_882191_DFB20DB5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Meenakshi,

On Mon, 2011-09-26 at 14:02 -0700, Henrik Friedrichsen wrote:
> Hey Meenakshi,
> 
> On Mon, Sep 26, 2011 at 10:59 PM, Venkataraman, Meenakshi
> <meenakshi.venkataraman@intel.com> wrote:
> > [MV] You're running Windows using the same card (6205), right? Also, have you ever seen good performance with your 6205 on your Linux system? What about with a different AP?
> 
> That's correct. On Windows the problem does not occur with that
> particular router. Also I don't think I have had comparable problems
> with other routers, at least not in my home (not on Linux, either).
> I'm using a different AP right now and it works just fine.

yes, we know this could be AP related, Larry also seeing some issues
against this AP, but I still like to understand and root cause the issue
and find a solution or W/A for it.

Henrik. what kind of traffic you are running? what I see from the log,
there are not many aggregated frames, (what I mean is I do not see a lot
of BA in the log) which is very different from what I am test here. also
I see the retry ratio is high in the aggregated frame compare to what I
have here.

Wey

  

