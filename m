Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-72-92-88-10.phlapa.fios.verizon.net ([72.92.88.10]:48047
	"EHLO smtp.roinet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbZJGMcX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2009 08:32:23 -0400
Message-ID: <4ACC8A32.5050704@roinet.com>
Date: Wed, 07 Oct 2009 08:31:46 -0400
From: David Acker <dacker@roinet.com>
MIME-Version: 1.0
To: Ahmed A <ahmedcali@yahoo.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Linux wifi development board
References: <911923.95402.qm@web32505.mail.mud.yahoo.com>
In-Reply-To: <911923.95402.qm@web32505.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ahmed A wrote:
> Hi David,
> 
> Thank you for your response.  I would like to explain what I am trying to setup, and would appreciate your feedback please.  My setup would comprise of two parts. One part would be the wifi router (base station), on which I load linux image bundled with my special app onto it.  The other part would be the wifi client (CPE), that would connect to the router.  I would also like to be able to load my own kernel image bundled with my special app.
> 
> I am guessing from your email, I would have to get a board from gateworks, hook up an antenna to it from ubnt, load image from OpenWRT, that would be my wifi router.  Is that right? Which product would you recommend, the Avilla platform? Which antenna from ubnt?  Would there be issues getting these to work?  How about the components on the client side, same deal?
> 
> I have done some work/programming on the IXP, but I do prefer a board with non-IXP CPU, like PowerPC or XScale.
> 
> Is there any solution out there, where the dev board and antenna come bundled, so I don't have to muck around getting them to work?
> 
> Any decent alternate board supplier, the prices of boards from gateworks are a bit pricey for me.

As someone else noted, the RouterStation Pro from Ubiquiti 
http://ubnt.com/products/rspro.php is a pretty good deal.  $80 gets you 
quite the system.  You could add in any of Ubiquiti's atheros based 
miniPCI radios.  They have 802.11b/g, 802.11a, and 802.11N in both 2.4 
and 5 GHz.  They also have several other frequencies like 2.3, 2.6, 4, 
900 MHz, and 700 MHz.  All of their radios are supported by either 
madwifi/ath5k or ath9k.

For all in one less expensive systems, I would look for an off the shelf 
wifi router that is supported by OpenWRT.  They have a nice list of 
supported routers.

-ack
