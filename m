Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:65298 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761937AbXHGSB2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2007 14:01:28 -0400
Message-ID: <46B8B372.3020709@lwfinger.net>
Date: Tue, 07 Aug 2007 13:01:22 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Pavel Roskin <proski@gnu.org>,
	bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] bcm43xx-mac80211: Remove the stackdump in rfatt/bbatt  assertion
References: <200708071815.09936.mb@bu3sch.de>
In-Reply-To: <200708071815.09936.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> This removes the stackdump in the rfatt/bbatt assertion
> to reduce verbosity, but it also increases the message log
> level from "debug" to "error".
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>

ACK: Larry Finger <Larry.Finger@lwfinger.net>

Michael - thanks for this.

Larry

