Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38440 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab2FKO7n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 10:59:43 -0400
Subject: Re: net: nfc: BUG and panic in accept() on 3.5-rc2
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
	David Miller <davem@davemloft.net>,
	lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	Dave Jones <davej@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20120611145700.GY22557@sortiz-mobl>
References: <1339423241.4999.53.camel@lappy>
	 <20120611144134.GX22557@sortiz-mobl>
	 <1339425693.6001.2268.camel@edumazet-glaptop>
	 <20120611145700.GY22557@sortiz-mobl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jun 2012 16:59:38 +0200
Message-ID: <1339426778.6001.2312.camel@edumazet-glaptop> (sfid-20120611_170001_935658_167B7DCE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-06-11 at 16:57 +0200, Samuel Ortiz wrote:
> Hi Eric,
> 
> On Mon, Jun 11, 2012 at 04:41:33PM +0200, Eric Dumazet wrote:
> > On Mon, 2012-06-11 at 16:41 +0200, Samuel Ortiz wrote:
> > > Hi Sasha,
> > > 
> > > On Mon, Jun 11, 2012 at 04:00:41PM +0200, Sasha Levin wrote:
> > > > Hi all,
> > > > 
> > > > I've stumbled on the following while fuzzing with trinity inside a KVM tools guest, running on 3.5-rc2:
> > > > 
> > > Thanks for the report, it could be worth adding this one to
> > > bugzilla.kernel.org.
> > > 
> > > What's trinity ?
> > > Also, if this one is reproducible, would you mind sharing some details about
> > > how we could reproduce it ?
> > 
> > Well, bugfix should be trivial enough ;)
> Yep, I looked at the code only after looking at Sasha's report.
> 
> Thanks for the patch, do you mind if I add your SOB to it ?

I would prefer making sure it fixes the bug first ;)

Thanks


