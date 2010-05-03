Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:16110 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756464Ab0ECWoI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 18:44:08 -0400
Subject: Re: [PATCH 2/4] rt2x00: Enable RT30xx by default.
From: Pavel Roskin <proski@gnu.org>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
In-Reply-To: <201005040008.36956.s.L-H@gmx.de>
References: <1272919385-18004-1-git-send-email-gwingerde@gmail.com>
	 <1272919385-18004-3-git-send-email-gwingerde@gmail.com>
	 <1272920358.4907.3.camel@mj>  <201005040008.36956.s.L-H@gmx.de>
Content-Type: text/plain
Date: Mon, 03 May 2010 18:44:03 -0400
Message-Id: <1272926643.6239.1.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-05-04 at 00:08 +0200, Stefan Lippers-Hollmann wrote:

> RT2800PCI_RT30XX is not a new/ separate module, its only function is to 
> limit the PCI ID space (to not claim PCI IDs for chipset generations not
> yet debugged properly) of rt2800pci.ko; this symbol isn't even used 
> anywhere else than within the PCI table.

I realize that.  Still, somebody upstream can object.

>  A 100% equivalent patch would be 
> to just drop the config option completely. I doubt that doing that would 
> meet resistance, as it merely adds previously 'unknown' (to be supported) 
> PCI IDs.

That's what I would do.

-- 
Regards,
Pavel Roskin
