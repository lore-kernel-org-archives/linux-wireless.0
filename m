Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38138 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759886AbZCMQsN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 12:48:13 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n2DGjcWp012731
	for <linux-wireless@vger.kernel.org>; Fri, 13 Mar 2009 12:45:38 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2DGmAob163638
	for <linux-wireless@vger.kernel.org>; Fri, 13 Mar 2009 12:48:10 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n2DGm9pp022134
	for <linux-wireless@vger.kernel.org>; Fri, 13 Mar 2009 12:48:10 -0400
Subject: Re: [LTP] Support of WIFI and W-LAN test cases in LTP
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: rahul Baliyan <rahul.lpt@gmail.com>
Cc: ltp-list@lists.sf.net, Jouni Malinen <j@w1.fi>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Jouni.Malinen" <Jouni.Malinen@atheros.com>
In-Reply-To: <9a14a0630903130632s36a7f059hd093d30e97f894eb@mail.gmail.com>
References: <9a14a0630903130632s36a7f059hd093d30e97f894eb@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 13 Mar 2009 22:17:54 +0530
Message-Id: <1236962876.7439.3.camel@subratamodak.linux.ibm.com> (sfid-20090313_174819_350560_02BFD4D5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, 2009-03-13 at 19:02 +0530, rahul Baliyan wrote:
> Hi,
> 
> Pl.  confirm if LTP contains the test cases of W-LAN and WI-FI.

Nope. We do not have till now. However, we initiated some discussion
some 6 months back in the same mailing list regarding Wireless Mesh
Netwoking tests. Please follow the following thread:

http://marc.info/?t=121969812900007&r=1&w=2&n=4,

There are some tests already avilable. We need somebody to volunteer to
bring them to some shape so that they can be automated and then
integrated inside LTP. Would you be ready to do that ?

Regards--
Subrata

> 
> if so, please share the location in LTP package.
> 
> 
> Regards,
> Rahul
> ------------------------------------------------------------------------------
> Apps built with the Adobe(R) Flex(R) framework and Flex Builder(TM) are
> powering Web 2.0 with engaging, cross-platform capabilities. Quickly and
> easily build your RIAs with Flex Builder, the Eclipse(TM)based development
> software that enables intelligent coding and step-through debugging.
> Download the free 60 day trial. http://p.sf.net/sfu/www-adobe-com
> _______________________________________________ Ltp-list mailing list Ltp-list@lists.sourceforge.net https://lists.sourceforge.net/lists/listinfo/ltp-list

