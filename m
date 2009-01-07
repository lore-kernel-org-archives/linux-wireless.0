Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:43857 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbZAGSI2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 13:08:28 -0500
Message-ID: <4964EF8D.7050803@oracle.com> (sfid-20090107_190832_594610_661D3B17)
Date: Wed, 07 Jan 2009 10:08:13 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: Tree for January 7 (ath9k)
References: <20090107170646.8d44292b.sfr@canb.auug.org.au>
In-Reply-To: <20090107170646.8d44292b.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stephen Rothwell wrote:
> Hi all,
> 
> The powerpc ppc44x_defconfig builds again.
> 
> Changes since 20090106:


drivers/built-in.o: In function `ath_detach':
main.c:(.text+0x16c6dc): undefined reference to `rfkill_unregister'
drivers/built-in.o: In function `ath_rfkill_poll':
main.c:(.text+0x16ce4e): undefined reference to `rfkill_force_state'
drivers/built-in.o: In function `ath9k_start':
main.c:(.text+0x16e034): undefined reference to `rfkill_register'
main.c:(.text+0x16e06d): undefined reference to `rfkill_free'
drivers/built-in.o: In function `ath_pci_probe':
main.c:(.text+0x16f9d1): undefined reference to `rfkill_allocate'

when CONFIG_RFKILL=n.


-- 
~Randy
