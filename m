Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57448 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996Ab0AHENk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 23:13:40 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 07 Jan 2010 20:13:40 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19270.46317.374569.436426@gargle.gargle.HOWL>
Date: Fri, 8 Jan 2010 10:00:37 +0530
To: Rainer Koschnick <arkay@gmx.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath9k driver in kernel 2.6.33 problems
In-Reply-To: <4B46730E.7000105@gmx.net>
References: <4B46730E.7000105@gmx.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rainer Koschnick wrote:
> Hi,
> 
> I've been trying to use the last couple of 2.6.33 RCs up to rc3-git2 and
> am experiencing connection issues with the ath9k driver.  It used to be
> broken for me in kernel 2.6.31 (haven't tried earlier), then was
> rock-solid in 2.6.32 and now it's broken again.  I can connect to my
> 300mbit router--which is in the same room--without problems, but after a
> while the connection breaks.

You could build the driver with CONFIG_ATH_DEBUG=y and CONFIG_ATH9K_DEBUGFS=y
and post the log, along with the contents of 'rcstat' and 'interrupt' debugfs files.

See: http://wireless.kernel.org/en/users/Drivers/ath9k/debug

Sujith
