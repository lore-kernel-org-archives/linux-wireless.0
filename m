Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:47398 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbYEIFQc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2008 01:16:32 -0400
Message-ID: <58931.84.58.138.216.1210308615.squirrel@webmail.madwifi.org> (sfid-20080509_071533_902097_CF19D075)
In-Reply-To: <fvv15v$9jr$1@ger.gmane.org>
References: <fvp2dg$d26$1@ger.gmane.org> <fvp2kq$d26$2@ger.gmane.org>
    <59055.84.58.170.93.1210134215.squirrel@webmail.madwifi.org>
    <fvv15v$9jr$1@ger.gmane.org>
Date: Fri, 9 May 2008 06:50:15 +0200 (CEST)
Subject: Re: is there support for my Card
From: "Michael Renzmann" <mrenzmann@madwifi.org>
To: "Markus Feldmann" <feldmann_markus@gmx.de>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

Markus Feldmann wrote:
>>> AR5BXB61
>> That's an AR5007-based card
> Are you sure.

Now that I read the name of the card again: no, I'm not sure. I guess I
assumed you might have mistyped the name and meant AR5BXB6*3*. It seems
that AR5BXB61 does exist, too, so what I wrote before might be wrong.

> However on Boot my System shows a W-Lan Card of the Type AR5006EG.

If that information comes from lspci, it might be wrong. If it comes from
ath5k, it's most probably correct. However, you could double-check using
the ath_info tool [1].

Bye, Mike

[1] http://madwifi.org/wiki/UserDocs/AthInfo
