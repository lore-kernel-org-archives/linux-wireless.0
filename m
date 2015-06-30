Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24714 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbbF3IuV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2015 04:50:21 -0400
Date: Tue, 30 Jun 2015 11:50:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dean Lee <dean.lee@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, rachel.kim@atmel.com,
	chris.park@atmel.com, nicolas.ferre@atmel.com, johnny.kim@atmel.com
Subject: Re: [PATCH 1/6] staging: wilc1000: modify build error
Message-ID: <20150630085007.GK28762@mwanda> (sfid-20150630_105028_301543_292134A7)
References: <1435653278-5168-1-git-send-email-dean.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1435653278-5168-1-git-send-email-dean.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 30, 2015 at 05:34:33PM +0900, Dean Lee wrote:
> this function needs more arguments.
> 

Sudip sent a patch for this but he passed false instead of true.

We are disconnecting because we got CONN_DISCONN_EVENT_DISCONN_NOTIF as
a response which seems like not locally generated.  I think false is
correct here.

regards,
dan carpenter

