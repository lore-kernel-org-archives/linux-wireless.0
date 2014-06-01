Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35231 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaFAF1R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jun 2014 01:27:17 -0400
Date: Sun, 1 Jun 2014 08:26:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrea Merello <andrea.merello@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Bernhard Schiffner <bernhard@schiffner-limbach.de>
Subject: Re: [PATCH 1/3] rtl818x_pci: make RSSI code more readable
Message-ID: <20140601052643.GM17724@mwanda> (sfid-20140601_072721_809054_22118F04)
References: <1401553786-7603-1-git-send-email-andrea.merello@gmail.com>
 <20140531200556.GL17724@mwanda>
 <CAN8YU5OFqTa0Ywwhgt_MzTA5+5v9YON_YkQyD3L+syCyjO+OKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAN8YU5OFqTa0Ywwhgt_MzTA5+5v9YON_YkQyD3L+syCyjO+OKw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 01, 2014 at 02:37:51AM +0200, Andrea Merello wrote:
> IHMO it does not matter.
> 
> The 10 is a stub value for rtl8187se (because of not-implemented-yet
> RSSI calculation), and indeed it is still here, in the rtl8187se case.
> This has the functional role of providing a valid >0 value for reported RSSI.
> This should hopefully go away soon :)
> So, for rtl8187se case, it always reported 10, and it does continue to do this.
> 
> The initialization to 1 has no any functional role, it is just to shut
> up gcc complaints about not initialized variable, but it should be
> always overwritten by one of the three cases, and we should never see
> this value really reported on RSSI measure.
> 
> Indeed they are two random values (chosen >0, just in case it does matter..)..
> 

Ah.  Ok.  Thanks.

regards,
dan carpenter

