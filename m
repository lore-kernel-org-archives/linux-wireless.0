Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:45905 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744Ab1IZQGl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 12:06:41 -0400
Subject: Re: iwlagn: "Intel Centrino Advanced-N 6205 AGN" and "AVM
 Fritz!Box (7390)" incompatible
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Henrik Friedrichsen <hrkfdn@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <CAJTrwG7tzDHxDha5x8r-GJFK=oUE6Zk5zqpN4z4L2LyAD=DueQ@mail.gmail.com>
References: <CAJTrwG5M5QtS_jw-WmbSb5_NT+m6JcBD0uHCyUzEYhn94G3rkA@mail.gmail.com>
	 <CAJTrwG47wxJMjxo9_gtwut0w17FS2Qz7BOBPc2XCLo39M7WvSQ@mail.gmail.com>
	 <1317048872.2400.4.camel@wwguy-ubuntu>
	 <CAJTrwG5CQKn9=1=HUDX1L5PsFbGws_zK1DTvot9i=KcMX7SwkQ@mail.gmail.com>
	 <1317049160.1958.8.camel@wwguy-huron>
	 <CAJTrwG5eELbDuGFXU4=3gSunPSkKLFvcpSe6gGE_Wc0s5BXZ+A@mail.gmail.com>
	 <CAJTrwG7tzDHxDha5x8r-GJFK=oUE6Zk5zqpN4z4L2LyAD=DueQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Sep 2011 08:19:40 -0700
Message-ID: <1317050380.1958.13.camel@wwguy-huron> (sfid-20110926_180644_511055_05AC118E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-09-26 at 09:03 -0700, Henrik Friedrichsen wrote:
> On Mon, Sep 26, 2011 at 4:59 PM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
> > few things I will suggest and please give a try:
> > 1. Please try to apply the following two patches I attach here.
> > 2. load the iwlagn with debug=0x45800006, the log will be big, but it
> > will contain more information on the tx/rx path.
> 
> Here's the log you asked for:
> http://diff.cc/tmp/kernel_iwlagn_2.log.bz2
> 
> As I said, this problem does not occur with the Windows driver. You
> said you are actively working on it. Does that mean, the problem is
> known to you?
> 

we are seeing performance issue and still can not root cause the
problem. that is the reason I send you 2 patches for testing. We are
very active working on fix the performance problem. the symptoms might
be different, but we aware there were issues.

Thx
Wey


