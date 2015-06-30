Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39027 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbbF3JKr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2015 05:10:47 -0400
Date: Tue, 30 Jun 2015 12:10:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Dean.lee" <dean.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, rachel.kim@atmel.com,
	chris.park@atmel.com, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	nicolas.ferre@atmel.com
Subject: Re: [PATCH 1/6] staging: wilc1000: modify build error
Message-ID: <20150630091024.GL28762@mwanda> (sfid-20150630_111052_298528_D0A5DFC1)
References: <1435653278-5168-1-git-send-email-dean.lee@atmel.com>
 <20150630085007.GK28762@mwanda>
 <55925A25.8030608@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <55925A25.8030608@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 30, 2015 at 05:58:13PM +0900, Dean.lee wrote:
> 
> 
> On 2015년 06월 30일 17:50, Dan Carpenter wrote:
> >On Tue, Jun 30, 2015 at 05:34:33PM +0900, Dean Lee wrote:
> >>this function needs more arguments.
> >>
> >Sudip sent a patch for this but he passed false instead of true.
> >
> >We are disconnecting because we got CONN_DISCONN_EVENT_DISCONN_NOTIF as
> >a response which seems like not locally generated.  I think false is
> >correct here.
> >
> >regards,
> >dan carpenter
> >
> i simply sync linux-next repository.

Yeah.  Stephen Rothwell changed it to true so that linux-next would
compile, but he is not a specialist here so I think he may have got it
wrong.

regards,
dan carpenter

