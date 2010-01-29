Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53998 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab0A2Pah (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2010 10:30:37 -0500
Date: Fri, 29 Jan 2010 10:27:03 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Greg Munroe <gmunroe@keywcorp.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Why was the D-Link DWA-160 A2 reverted
Message-ID: <20100129152703.GB23491@tuxdriver.com>
References: <4B6B69AB42555546BF8AEBDA21196517BBA4B3@ihq-app01.keywcorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4B6B69AB42555546BF8AEBDA21196517BBA4B3@ihq-app01.keywcorp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 28, 2010 at 03:37:08PM -0500, Greg Munroe wrote:
> Does anyone know why the D-Link DWA-160 A2 (07d1:3a09) was added
> 11/17/2009 and reverted 12/18/2009?

You mean this one (from drivers/net/wireless/ath/ar9170/usb.c)?

	/* D-Link DWA 160 A2 */
	{ USB_DEVICE(0x07d1, 0x3a09) },

Please check the source.  The logs from wireless-testing can be
confusing...  With the new process for managing wireless tree that
started with the current cycle this sort of thing should be less of
a problem, but still wireless-testing's logs should _not_ be treated
as authoritative.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
