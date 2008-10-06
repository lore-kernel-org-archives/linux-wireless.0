Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:45867 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbYJFVYn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 17:24:43 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] p54: fix build failure
Date: Mon, 6 Oct 2008 23:28:43 +0200
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <1223322501.3778.20.camel@johannes.berg> <200810062245.32965.chunkeey@web.de> <1223326065.3778.32.camel@johannes.berg>
In-Reply-To: <1223326065.3778.32.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810062328.43943.chunkeey@web.de> (sfid-20081006_232447_290500_797088C2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 06 October 2008 22:47:45 Johannes Berg wrote:
> still HTML and as such not really useful.
>
if only kmail let me disable it! :-)
Is it off now? If not, I'm really sorry, for all html ****.
I'll fix it, but it'll take another while.

> However,
>
> > +int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int
> > len);
>
> How about just killing the export instead? It isn't used anywhere else
> anyway?

True.

on the other hand: what about stlc45xx (p54spi)?
These ?SoC? chips don't have any eeprom attached to the I2C, but they
need calibration data and output power limits like the usb/pci parts as well.

Regards,
	Chr 
