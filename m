Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:36388 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbYEGE4U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2008 00:56:20 -0400
Message-ID: <59055.84.58.170.93.1210134215.squirrel@webmail.madwifi.org> (sfid-20080507_065529_786148_A3F6C94C)
In-Reply-To: <fvp2kq$d26$2@ger.gmane.org>
References: <fvp2dg$d26$1@ger.gmane.org> <fvp2kq$d26$2@ger.gmane.org>
Date: Wed, 7 May 2008 06:23:35 +0200 (CEST)
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
>> i only want to know if there is support in the next stable Kernel
>> 2.6.26 for my Card ?
> AR5BXB61

That's an AR5007-based card, for which Nick posted a patch recently [1]. I
don't know whether this patch will make it into 2.6.26. But even if it
does, support for AR5007 is still incomplete, as Nick states: "Add RF2425
initvals (still no rx/tx)". So ath5k might recognize and initialize your
card, but most probably won't work with it.

Bye, Mike
