Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51947 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755500AbZCSHAp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 03:00:45 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n2J6w4Af030607
	for <linux-wireless@vger.kernel.org>; Thu, 19 Mar 2009 02:58:04 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2J70hoY178668
	for <linux-wireless@vger.kernel.org>; Thu, 19 Mar 2009 03:00:43 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n2J70g4F020357
	for <linux-wireless@vger.kernel.org>; Thu, 19 Mar 2009 03:00:43 -0400
Subject: Re: [LTP] Support of WIFI and W-LAN test cases in LTP
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: rahul Baliyan <rahul.lpt@gmail.com>, ltp-list@lists.sf.net,
	Luis Carlos Cobo <luisca@cozybit.com>,
	Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Jouni.Malinen" <Jouni.Malinen@atheros.com>
In-Reply-To: <43e72e890903181242i1be5818et8afd1157cff8af83@mail.gmail.com>
References: <9a14a0630903130632s36a7f059hd093d30e97f894eb@mail.gmail.com>
	 <1236962876.7439.3.camel@subratamodak.linux.ibm.com>
	 <1237272937.5622.11.camel@subratamodak.linux.ibm.com>
	 <43e72e890903181242i1be5818et8afd1157cff8af83@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 19 Mar 2009 12:30:38 +0530
Message-Id: <1237446038.5260.9.camel@subratamodak.linux.ibm.com> (sfid-20090319_080048_662894_A7DBB9E6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-03-18 at 12:42 -0700, Luis R. Rodriguez wrote:
> On Mon, Mar 16, 2009 at 11:55 PM, Subrata Modak
> <subrata@linux.vnet.ibm.com> wrote:
> > Hi Rahul,
> >
> > On Fri, 2009-03-13 at 22:17 +0530, Subrata Modak wrote:
> >> Hi,
> >>
> >> On Fri, 2009-03-13 at 19:02 +0530, rahul Baliyan wrote:
> >> > Hi,
> >> >
> >> > Pl.  confirm if LTP contains the test cases of W-LAN and WI-FI.
> >>
> >> Nope. We do not have till now. However, we initiated some discussion
> >> some 6 months back in the same mailing list regarding Wireless Mesh
> >> Netwoking tests. Please follow the following thread:
> >>
> >> http://marc.info/?t=121969812900007&r=1&w=2&n=4,
> >>
> >> There are some tests already avilable. We need somebody to volunteer to
> >> bring them to some shape so that they can be automated and then
> >> integrated inside LTP. Would you be ready to do that ?
> >
> > Would you like to take up my proposal ?
> 
> BTW I've stashed a Linux wireless testing entry in the Linux
> Foundation GSoC, hopefully that can be merged back into LTP.
> 
> https://www.linuxfoundation.org/en/Google_Summer_of_Code_2009#Automation_of_testing_using_mac80211_hwsim_and_Orbit

Thanks. That would be really great. Send me the automation test patch
when it is ready with some results, etc.

Regards--
Subrata

> 
>   Luis

