Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:60702 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846AbZBTKel (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 05:34:41 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43: Add slot count compiletime assertion
Date: Fri, 20 Feb 2009 11:32:55 +0100
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200902200009.42967.mb@bu3sch.de>
In-Reply-To: <200902200009.42967.mb@bu3sch.de>
MIME-Version: 1.0
Message-Id: <200902201132.55783.mb@bu3sch.de> (sfid-20090220_113445_075167_4E4B2312)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 20 February 2009 00:09:42 Michael Buesch wrote:
> This adds a compiletime assertion for a recently introduced
> assumption on the slot counts.
> The tx header cache handling code assumes that the TX slot count
> can be divided evenly by the number of TX slots per frame.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> ---
> 
> Please queue on top of the DMA optimizations.

I wonder what I was smoking when doing this patch, yesterday.

I'll immediately get a brown paper bag and redo a sane version of this... :)


-- 
Greetings, Michael.
