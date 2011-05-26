Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50463 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436Ab1EZCcU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 May 2011 22:32:20 -0400
Subject: Re: iwlagn: is tx_power_device_lmt a regulatory limit or a
 hardware limit?
From: wwguy <wey-yi.w.guy@intel.com>
To: Stevie Trujillo <stevie.trujillo@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <201105252154.06204.stevie.trujillo@gmail.com>
References: <201105251813.36804.stevie.trujillo@gmail.com>
	 <1306352560.20732.0.camel@wwguy-ubuntu>
	 <201105252154.06204.stevie.trujillo@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 May 2011 19:28:58 -0700
Message-ID: <1306376938.20732.2.camel@wwguy-ubuntu> (sfid-20110526_043224_544481_ABA27B66)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-05-25 at 12:54 -0700, Stevie Trujillo wrote:
> On Wednesday 25 May 2011 21:42:40 wwguy wrote:
> > On Wed, 2011-05-25 at 09:13 -0700, Stevie Trujillo wrote:
> > > Hello,
> > > 
> > > I have a "Intel(R) Centrino(R) 1030 BGN" card. tx_power_device_lmt is 15
> > > and I was wondering if the card could do more than that.
> > 
> > the card should not and will not do more than what required by
> > regulatory
> 
> I'm allowed to do 20dBm here and was wondering if I could make the card do 
> that.
> 
the tx power in Intel WiFi device is regulated by uCode to make sure we
are within regulatory limits. What country you are in? 

Thanks
Wey


