Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45811 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab3KDMA5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Nov 2013 07:00:57 -0500
Date: Mon, 4 Nov 2013 15:00:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: brcm80211-dev-list@broadcom.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: How to get BRCM to work?
Message-ID: <20131104120046.GX20521@mwanda> (sfid-20131104_130102_557333_8DBF3AAA)
References: <20131104115111.GM26669@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131104115111.GM26669@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 04, 2013 at 02:51:11PM +0300, Dan Carpenter wrote:
> I've been trying to remember the trick to get BRCM to work and I can't
> remember at all.  I'm using BCM4313.  I've enabled everything with BCMA
> or BRCM in the config name.

Can we make BRCM select BCMA instead of depending on it?  No one wants
BCMA, they just want their wifi to work.  There is no reason that users
should have to grovel through Kconfig files to figure out how to compile
the broadcom driver instead of just using menuconfig like everyone else
does.

regards,
dan carpenter

