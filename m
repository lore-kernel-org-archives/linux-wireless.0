Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:55307 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568Ab2K2M4j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 07:56:39 -0500
Message-ID: <1354193757.5254.7.camel@cumari.coelho.fi> (sfid-20121129_135642_477123_A5669C65)
Subject: Re: [PATCH 20/20] wl18xx: set last Tx rate from FW status
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>
Date: Thu, 29 Nov 2012 14:55:57 +0200
In-Reply-To: <1353998701-18171-21-git-send-email-arik@wizery.com>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
	 <1353998701-18171-21-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-27 at 08:45 +0200, Arik Nemtsov wrote:
> Obtain the last Tx rate from the FW status and translate it to
> the mac80211 rate+flag format before sending it up via the Tx status.
> 
> Bump up the min FW version to the first FW that supports the rate byte.

This part of the comment doesn't apply anymore, because we already
bumped and this change is not part of this rebased patch. ;)

--
Luca.

