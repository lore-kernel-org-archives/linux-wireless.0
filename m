Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:33858 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932694AbXCDCoN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2007 21:44:13 -0500
Message-ID: <45EA3272.7090101@garzik.org>
Date: Sat, 03 Mar 2007 21:44:02 -0500
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcm43xx: remove ethtool
References: <45ea1a34.Lf4EKmMy+KAmSkH0%Larry.Finger@lwfinger.net>
In-Reply-To: <45ea1a34.Lf4EKmMy+KAmSkH0%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> Ethtool is useless for bcm43xx - remove it.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

How is GDRVINFO useless?  Where does mac80211 provide equivalent 
information?

	Jeff



