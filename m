Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:13173 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932695AbZGPQg6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 12:36:58 -0400
Subject: Re: PCI express card that does AP mode? (abit wlp-01?)
From: Pavel Roskin <proski@gnu.org>
To: Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <wfljmpm4xl.fsf@calligramme.charmers>
References: <wfljmpm4xl.fsf@calligramme.charmers>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 12:36:55 -0400
Message-Id: <1247762215.4235.21.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-07-16 at 09:02 +0100, Jon Fairbairn wrote:

> I've seen adverts for the Abit WLP-01, and elsewhere on the net seen
> implications that it's 168c:001c, which isn't listed at
> <http://wireless.kernel.org/en/users/Devices/PCI>, but
> <http://wireless.kernel.org/en/users/Drivers/ath5k> does list it and
> says AP mode not working, but mentions
> <http://madwifi-project.org/wiki/Compatibility/Abit>, which suggest AP
> mode works with madwifi. What's the current status?

ath5k will support the AP mode in Linux 2.6.31.  It's already in Linux
2.6.31-rc3.

-- 
Regards,
Pavel Roskin
