Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:21488 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab2ENJ0I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 05:26:08 -0400
Date: Mon, 14 May 2012 12:28:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org, Julia Lawall <julia@diku.dk>
Subject: Re: net: wireless: add brcm80211 drivers
Message-ID: <20120514092844.GD16999@mwanda> (sfid-20120514_112613_291248_4FE81FAB)
References: <20120513174333.GB4280@elgon.mountain>
 <4FB0AF4B.9070606@broadcom.com>
 <20120514083415.GA16999@mwanda>
 <4FB0CB01.3000507@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FB0CB01.3000507@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 14, 2012 at 11:06:09AM +0200, Arend van Spriel wrote:
> On 05/14/2012 10:34 AM, Dan Carpenter wrote:
> > On Mon, May 14, 2012 at 09:07:55AM +0200, Arend van Spriel wrote:
> > What Smatch does that Coccinelle doesn't is that it tries to track
> > the values of all the variables.  This means you can detect array
> > overflows, for example.  Smatch tries to track values across
> > function calls as well, with the recent database work.
> 
> I guess Oracle knows a thing or two about databases.

Uh...  It just puts all the information of how the functions are
called into an sqlite3 database.  Arg 3 is a number 0-9.

regards,
dan carpenter

