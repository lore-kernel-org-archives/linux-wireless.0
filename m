Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:51561 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696Ab1IZTUQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 15:20:16 -0400
Subject: Re: iwlagn: "Intel Centrino Advanced-N 6205 AGN" and "AVM
 Fritz!Box (7390)" incompatible
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Henrik Friedrichsen <hrkfdn@gmail.com>
Cc: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <CAJTrwG5AvbtNRZi54tzAoUDv5X9QLVY3L=-OgHYRtnJ-RMesrQ@mail.gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Sep 2011 11:33:24 -0700
Message-ID: <1317062004.1958.18.camel@wwguy-huron> (sfid-20110926_212020_560867_8EDE23F5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Henrik,

 
On Mon, 2011-09-26 at 11:26 -0700, Henrik Friedrichsen wrote:
> Hey Meenakshi
> 
> On Mon, Sep 26, 2011 at 7:58 PM, Venkataraman, Meenakshi
> <meenakshi.venkataraman@intel.com> wrote:
> > [MV] Just to verify that this is a 11n issue, you said you tried disabling the 11n mode?
> Yes. I just did, once again, to verify it. No change, unfortunately :(
> 
> > Also, in your first email you mentioned that you were using 3.0.4 earlier? What were the results in that version?
> It was the same. I was hoping a newer kernel might contain a fix of
> some sort, that's why I updated it.
> 
> > I wonder if we're somehow using very low rates. Can you please send debug logs from your experiment with debug flags 0x143fff?
> Here are the logs: http://diff.cc/tmp/kernel_iwlagn_3.log.bz2
> They were made with "11n_disable=1" and without the patches posted by Wey-Yi.
> 

One experiment if you can help us to test.

please reset the repository to
commit#1f7b6172db86e9ab2b4cd794441bb2c40ab287fc

and give a try to see if you still seeing the issue.

Thanks
Wey


