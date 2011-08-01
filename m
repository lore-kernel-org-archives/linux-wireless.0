Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:41202 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752243Ab1HAV72 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2011 17:59:28 -0400
Date: Mon, 1 Aug 2011 14:52:46 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-wireless@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: Re: linux-next: Tree for Aug 1 (wireless/rt2x00)
Message-Id: <20110801145246.da67280d.rdunlap@xenotime.net> (sfid-20110801_235946_322663_48C324F1)
In-Reply-To: <20110801144732.7f5204b219f628f2a2a63b0c@canb.auug.org.au>
References: <20110801144732.7f5204b219f628f2a2a63b0c@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 1 Aug 2011 14:47:32 +1000 Stephen Rothwell wrote:

> Hi all,

When CONFIG_RT2X00_LIB_CRYPTO is not enabled:

drivers/net/wireless/rt2x00/rt2x00queue.c:476: error: too many arguments to function 'rt2x00crypto_create_tx_descriptor'


CONFIG_RT2X00=m
# CONFIG_RT2400PCI is not set
CONFIG_RT2500PCI=m
# CONFIG_RT61PCI is not set
# CONFIG_RT2800PCI is not set
CONFIG_RT2X00_LIB_PCI=m
CONFIG_RT2X00_LIB=m
CONFIG_RT2X00_LIB_LEDS=y
# CONFIG_RT2X00_DEBUG is not set

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
