Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:3840 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbYELLp3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2008 07:45:29 -0400
Subject: Re: is there support for my Card
From: Pavel Roskin <proski@gnu.org>
To: Markus Feldmann <feldmann_markus@gmx.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1210562893.2345.12.camel@dv>
References: <fvp2dg$d26$1@ger.gmane.org> <fvp2kq$d26$2@ger.gmane.org>
	 <59055.84.58.170.93.1210134215.squirrel@webmail.madwifi.org>
	 <fvv15v$9jr$1@ger.gmane.org>
	 <58931.84.58.138.216.1210308615.squirrel@webmail.madwifi.org>
	 <g01c9i$8ud$1@ger.gmane.org>  <1210562893.2345.12.camel@dv>
Content-Type: text/plain
Date: Mon, 12 May 2008 07:45:28 -0400
Message-Id: <1210592728.3372.9.camel@dv> (sfid-20080512_134532_478690_8BC2FAAC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-05-11 at 23:28 -0400, Pavel Roskin wrote:

> It you want to figure out the exact MAC, I suggest that you load some
> driver that can enable the card, such as the current version of madwifi
> from Subversion.  If it works, it's AR5006, otherwise AR5007.  There is
> also a special snapshot of madwifi with AR5007 support at 

http://snapshots.madwifi.org/special/

Look for "ar5007" in the names.  Sorry, missed the link.

-- 
Regards,
Pavel Roskin
