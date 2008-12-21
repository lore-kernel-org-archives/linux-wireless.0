Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:32803 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751082AbYLUXRx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2008 18:17:53 -0500
Message-ID: <494ECE9E.9020100@lwfinger.net> (sfid-20081222_001757_409296_2D33B252)
Date: Sun, 21 Dec 2008 17:17:50 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [RFC/RFT] p54: regulatory domain hint
References: <200812212336.31267.chunkeey@web.de>
In-Reply-To: <200812212336.31267.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> This patch adds a sub-routine that parses the default country eeprom entry
> and forwards the obtained Alpha2 identifier to the regulatory sub-system.

My p54usb now recognizes that the US domain should be used, not the world value.

ACK.

Larry

