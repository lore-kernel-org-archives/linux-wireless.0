Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgate.cesmail.net ([216.154.195.36]:52767 "HELO
	mailgate.cesmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932282AbXDUEMy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Apr 2007 00:12:54 -0400
Message-ID: <20070421001253.q449myskosg0sg8k@webmail.spamcop.net>
Date: Sat, 21 Apr 2007 00:12:53 -0400
From: Pavel Roskin <proski@gnu.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ieee80211: Output frequency rather than channel in  scan results
References: <46298e00.m7oDqYNvDCFdCSj1%Larry.Finger@lwfinger.net>
In-Reply-To: <46298e00.m7oDqYNvDCFdCSj1%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Larry Finger <Larry.Finger@lwfinger.net>:

> In ieee80211, the output of scan results lists channels rather than
> frequencies; however, NetworkManager needs frequency. This patch
> changes the output from channel to frequency.

The driver can report both, and I think it should.  This would make the iwlist
output a bit longer, but kernel drivers shouldn't be written to make userspace
program generate pretty output.

--
Regards,
Pavel Roskin
