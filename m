Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:59545 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbZAINvF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 08:51:05 -0500
From: Christian Lamparter <chunkeey@web.de>
To: wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/3] p54: p54spi driver
Date: Fri, 9 Jan 2009 14:51:01 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John W Linville <linville@tuxdriver.com>
References: <200901010201.44229.chunkeey@web.de>
In-Reply-To: <200901010201.44229.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901091451.01499.chunkeey@web.de> (sfid-20090109_145111_257089_8B4CD162)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 01 January 2009 02:01:43 Christian Lamparter wrote:
> This patch series introduce the back-end driver p54spi for stlc4550/stlc4560 chips.
> 
> So far no one complained about the patches or had any other issues...
> => therefore it must be 100% working!
> 
> [Please mind the logic gap ;-) , But I hope someone will respond
> when the whole driver can be easily built with compat-wireless.]
> 
> Regards,
> 	Chr
John?

I found a "few" bugs in the series, I'll do a re spin later...

In the meantime, do you still have this patch somewhere in your inbox?
http://www.spinics.net/lists/linux-wireless/msg24853.html

Regards,
	Chr
