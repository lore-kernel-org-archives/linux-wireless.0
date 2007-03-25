Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgate.cesmail.net ([216.154.195.36]:33584 "HELO
	mailgate.cesmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751141AbXCYPWg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Mar 2007 11:22:36 -0400
Message-ID: <20070325112235.tjuz5c04kcs4044g@webmail.spamcop.net>
Date: Sun, 25 Mar 2007 11:22:35 -0400
From: Pavel Roskin <proski@gnu.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcm43xx: Fix machine check on PPC for version 1 PHY
References: <46067d12.1uF8l72xIYAG6Vyb%Larry.Finger@lwfinger.net>
In-Reply-To: <46067d12.1uF8l72xIYAG6Vyb%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Larry!

That was quick!  I confirm that the patch fixes the machine check for me.  The
driver is working, even with WEP.  To prove my point, I'll send this message
over the fixed driver, so if you can read it, you have made an excellent job :)

--
Regards,
Pavel Roskin
