Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52691 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbZI0SRA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Sep 2009 14:17:00 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e7.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id n8RIEiF5011654
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2009 14:14:44 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n8RIH4G9237560
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2009 14:17:04 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n8RIDkkn017775
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2009 14:13:47 -0400
Subject: Re: [LTP] Support of WIFI and W-LAN test cases in LTP
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: Georgy Berdyshev <codingmaster@gmail.com>
Cc: ltp-list@lists.sf.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	rahul Baliyan <rahul.lpt@gmail.com>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Jouni.Malinen" <Jouni.Malinen@atheros.com>
In-Reply-To: <1252847807.5357.36.camel@subratamodak.linux.ibm.com>
References: <9a14a0630903130632s36a7f059hd093d30e97f894eb@mail.gmail.com>
	 <1236962876.7439.3.camel@subratamodak.linux.ibm.com>
	 <1237272937.5622.11.camel@subratamodak.linux.ibm.com>
	 <43e72e890903181242i1be5818et8afd1157cff8af83@mail.gmail.com>
	 <1237446038.5260.9.camel@subratamodak.linux.ibm.com>
	 <1245768529.4860.61.camel@subratamodak.linux.ibm.com>
	 <43e72e890906230831q6e6c9e2v49454ab66ca99156@mail.gmail.com>
	 <ee8eb53d0906231508ta738039m562dee936319624c@mail.gmail.com>
	 <1245921029.5542.44.camel@subratamodak.linux.ibm.com>
	 <1252847807.5357.36.camel@subratamodak.linux.ibm.com>
Content-Type: text/plain
Date: Sun, 27 Sep 2009 23:45:53 +0530
Message-Id: <1254075355.10457.32.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2009-09-13 at 18:46 +0530, Subrata Modak wrote: 
> Hi Georgy,
> 
> On Thu, 2009-06-25 at 14:40 +0530, Subrata Modak wrote: 
> > On Tue, 2009-06-23 at 19:08 -0300, Georgy Berdyshev wrote: 
> > > Hi,
> > > 
> > > Luis did already mention that the idea is to contribute things back to
> > > LTP or have LTP use it.
> > 
> 
> Any headway towards Code contribution to LTP ?

Ping.

> 
> Regards--
> Subrata
> 
> > Great to hear that again. I was trying to figure out the status of that
> > work ? When is it expected to complete, any idea ?
> > 
> > Regards--
> > Subrata
> > 
> > > In case that there is some work going on, I would like to merge those
> > > tests also into my project
> > > and later on extend the work with LTP.
> > > 
> > > In any case, feel free to contact me.
> > > 
> > > Regards, Georgy
> > > 
> > > On Tue, Jun 23, 2009 at 12:31 PM, Luis R.
> > > Rodriguez<lrodriguez@atheros.com> wrote:
> > > > On Tue, Jun 23, 2009 at 7:48 AM, Subrata
> > > > Modak<subrata@linux.vnet.ibm.com> wrote:
> > > >> On Thu, 2009-03-19 at 12:30 +0530, Subrata Modak wrote:
> > > >>> On Wed, 2009-03-18 at 12:42 -0700, Luis R. Rodriguez wrote:
> > > >>> > On Mon, Mar 16, 2009 at 11:55 PM, Subrata Modak
> > > >>> > <subrata@linux.vnet.ibm.com> wrote:
> > > >>> > > Hi Rahul,
> > > >>> > >
> > > >>> > > On Fri, 2009-03-13 at 22:17 +0530, Subrata Modak wrote:
> > > >>> > >> Hi,
> > > >>> > >>
> > > >>> > >> On Fri, 2009-03-13 at 19:02 +0530, rahul Baliyan wrote:
> > > >>> > >> > Hi,
> > > >>> > >> >
> > > >>> > >> > Pl.  confirm if LTP contains the test cases of W-LAN and WI-FI.
> > > >>> > >>
> > > >>> > >> Nope. We do not have till now. However, we initiated some discussion
> > > >>> > >> some 6 months back in the same mailing list regarding Wireless Mesh
> > > >>> > >> Netwoking tests. Please follow the following thread:
> > > >>> > >>
> > > >>> > >> http://marc.info/?t=121969812900007&r=1&w=2&n=4,
> > > >>> > >>
> > > >>> > >> There are some tests already avilable. We need somebody to volunteer to
> > > >>> > >> bring them to some shape so that they can be automated and then
> > > >>> > >> integrated inside LTP. Would you be ready to do that ?
> > > >>> > >
> > > >>> > > Would you like to take up my proposal ?
> > > >>> >
> > > >>> > BTW I've stashed a Linux wireless testing entry in the Linux
> > > >>> > Foundation GSoC, hopefully that can be merged back into LTP.
> > > >>> >
> > > >>> > https://www.linuxfoundation.org/en/Google_Summer_of_Code_2009#Automation_of_testing_using_mac80211_hwsim_and_Orbit
> > > >>>
> > > >>
> > > >> Hi,
> > > >>
> > > >> Is somebody working on this, and still interested to contribute the same
> > > >> to LTP ?
> > > >
> > > > Yes, the idea is to hopefully contribute it back to LTP. Or have LTP
> > > > use it. I've added Georgy, the student working on this project.
> > > >
> > > >  Luis
> > > >
> > > 
> > > 
> > > 
> > 
> > 
> > ------------------------------------------------------------------------------
> > _______________________________________________
> > Ltp-list mailing list
> > Ltp-list@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/ltp-list
> 
> 
> ------------------------------------------------------------------------------
> Let Crystal Reports handle the reporting - Free Crystal Reports 2008 30-Day 
> trial. Simplify your report design, integration and deployment - and focus on 
> what you do best, core application coding. Discover what's new with 
> Crystal Reports now.  http://p.sf.net/sfu/bobj-july
> _______________________________________________
> Ltp-list mailing list
> Ltp-list@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/ltp-list

