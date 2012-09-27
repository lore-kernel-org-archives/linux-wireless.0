Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48052 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756312Ab2I0HA3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 03:00:29 -0400
Message-ID: <1348729265.10353.1.camel@jlt4.sipsolutions.net> (sfid-20120927_090040_257767_1B31616F)
Subject: Re: [PATCH v2] mac80211: VHT peer STA caps
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 27 Sep 2012 09:01:05 +0200
In-Reply-To: <5063F372.2040601@posedge.com>
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCF5269@mbx022-e1-nj-10.exch022.domain.local>
	      <1348477154.10257.2.camel@jlt4.sipsolutions.net>
	      <50614089.6020105@posedge.com>
	     <1348557902.10041.17.camel@jlt4.sipsolutions.net>
	     <50617E2C.6050000@posedge.com>
	    <1348582152.10041.36.camel@jlt4.sipsolutions.net>
	    <5062736B.9060008@posedge.com>
	   <1348660422.10548.10.camel@jlt4.sipsolutions.net>
	   <506339C3.40405@posedge.com>
	  <1348682036.10548.13.camel@jlt4.sipsolutions.net>
	  <5063C6B1.8030301@posedge.com>
	 <1348727075.10353.0.camel@jlt4.sipsolutions.net>
	 <5063F372.2040601@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-09-27 at 12:04 +0530, Mahesh Palivela wrote:
> On 09/27/2012 11:54 AM, Johannes Berg wrote:
> >> Thanks for the pointer. will revert with code change.
> >
> > Well, reverting that change would be pointless?
> >
> > Better just add some text there to the docs.
> >
> 
> Sorry wrong usage of word revert. what I meant was get back with proper 
> mask bits code change.
> Also update docs section accordingly.

I think it's fine if you leave the code as is, but change the comment to
make the HT/VHT difference clear.

johannes

