Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41128 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889Ab1FJSBH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 14:01:07 -0400
Subject: Re: iwlagn: is tx_power_device_lmt a regulatory limit or a
 hardware limit?
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Richard =?ISO-8859-1?Q?Sch=FCtz?= <r.schtz@t-online.de>
Cc: Stevie Trujillo <stevie.trujillo@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4DF246D1.9000107@t-online.de>
References: <201105251813.36804.stevie.trujillo@gmail.com>
	 <1306352560.20732.0.camel@wwguy-ubuntu>
	 <201105252154.06204.stevie.trujillo@gmail.com>
	 <1306376938.20732.2.camel@wwguy-ubuntu>  <4DDE1458.9090004@t-online.de>
	 <1306419109.20732.6.camel@wwguy-ubuntu>  <4DF246D1.9000107@t-online.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Jun 2011 10:31:23 -0700
Message-ID: <1307727083.13397.57.camel@wwguy-huron> (sfid-20110610_200111_705325_BA0AECF9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-06-10 at 09:31 -0700, Richard Schütz wrote:
> On 26.05.2011 16:11, wwguy wrote:
> > On Thu, 2011-05-26 at 01:50 -0700, Richard Schütz wrote:
> >>> On Wed, 2011-05-25 at 12:54 -0700, Stevie Trujillo wrote:
> >>>> On Wednesday 25 May 2011 21:42:40 wwguy wrote:
> >>>>> On Wed, 2011-05-25 at 09:13 -0700, Stevie Trujillo wrote:
> >>>>>> Hello,
> >>>>>>
> >>>>>> I have a "Intel(R) Centrino(R) 1030 BGN" card. tx_power_device_lmt is 15
> >>>>>> and I was wondering if the card could do more than that.
> >>>>>
> >>>>> the card should not and will not do more than what required by
> >>>>> regulatory
> >>>>
> >>>> I'm allowed to do 20dBm here and was wondering if I could make the card do
> >>>> that.
> >>>>
> >>> the tx power in Intel WiFi device is regulated by uCode to make sure we
> >>> are within regulatory limits. What country you are in?
> >>>
> >>> Thanks
> >>> Wey
> >>
> >> I am also having the same issue with my Intel PRO/Wireless 5100 AGN.
> >> Here in Germany I'm allowed to use 20 dBm (in the 2.4 GHz band), but the
> >> card is limited to 15 dBm. So in some situations other cards are working
> >> fine (as they use 20 dBm) and the Intel can't establish a connection.
> >>
> > We do not have different SKUs for different regions of the world. Now I
> > understand your problem. Thank you very much for reporting. I will raise
> > the issue and see how we should fix it.
> >
> > Sorry, I don't have a solution for you today. But it is very important
> > for us and we need to result it.
> >
> > Thanks
> > Wey
> 
> Is there any news?
> 
Hi, I talk to the marketing and since we are providing single SKU
solution, the maximum allowed tx power is programmed in EEPROM, so
currently there is no method to allow use the higher limitation.

Thanks
Wey


