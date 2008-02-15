Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qvfw1.qvalent.com ([202.7.65.65]:60255 "HELO mail.qvalent.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S933881AbYBOGzb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 01:55:31 -0500
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Message-Id: <DF448D07-5C48-43C0-B6DD-12AF17BE0943@serialmonkey.com> (sfid-20080215_065536_696917_696701F2)
From: Mark Wallis <mwallis@serialmonkey.com>
To: Pavel Roskin <proski@gnu.org>
In-Reply-To: <1203056096.30732.63.camel@dv>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: Both rt2500usb and rt73 claim USB device 148f:2573
Date: Fri, 15 Feb 2008 17:24:08 +1100
References: <1203056096.30732.63.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Pavel,

On 15/02/2008, at 5:14 PM, Pavel Roskin wrote:

> My Level One WNC-0301USB v3 has USB ID 148f:2573, which is listed as
> compatible both in rt2500usb.c and rt73usb.c.  It only works with rt73
> but not with rt2500usb.
>
> Is this duplication intentional?

I'm afraid so. That particular manufacturer I believe changed the  
chipset they were using without updating their USD device ID's. We  
have seen this a few times now and the only solution we have been able  
to provide is to give the users instructions for blacklisting the  
incorrect driver.

I believe this has been discussed on this list previously.

Regards,
Mark Wallis
rt2x00 Driver Team
mwallis@serialmonkey.com
http://www.markwallis.id.au
