Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:27138 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab2DTJM0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 05:12:26 -0400
Date: Fri, 20 Apr 2012 12:14:49 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] wireless: at76c50x: allocating too much data
Message-ID: <20120420091449.GI27101@mwanda> (sfid-20120420_111231_462229_49DF6D29)
References: <20120420064705.GE22649@elgon.mountain>
 <CAGRGNgVgtAYknmpB_8Q0OpcUWFjTxBistG+RNs1ORDZeckGsWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAGRGNgVgtAYknmpB_8Q0OpcUWFjTxBistG+RNs1ORDZeckGsWw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 20, 2012 at 06:57:00PM +1000, Julian Calaby wrote:
> > -       struct mib_local *m = kmalloc(sizeof(struct mib_phy), GFP_KERNEL);
> > +       struct mib_local *m = kmalloc(sizeof(struct mib_local), GFP_KERNEL);
> 
> Would it be better practice to use sizeof(*m)?
> 

That was my temptation as well...  But I decided to make it match
with the surrounding code.  I'm happy to resend if people want.

regards,
dan carpenter

