Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44898 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbZGXSp5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 14:45:57 -0400
Date: Fri, 24 Jul 2009 14:35:03 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/6] ath9k: Add debug counters for TX
Message-ID: <20090724183502.GA2711@tuxdriver.com>
References: <19048.13623.675052.94639@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <19048.13623.675052.94639@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 23, 2009 at 03:32:31PM +0530, Sujith wrote:
> Location: ath9k/phy#/xmit
> 
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>

Eeek!

  CC [M]  drivers/net/wireless/ath/ath9k/hw.o
In file included from drivers/net/wireless/ath/ath9k/ath9k.h:28,
                 from drivers/net/wireless/ath/ath9k/hw.c:21:
drivers/net/wireless/ath/ath9k/debug.h:201: warning: ‘struct ath_buf’ declared inside parameter list
drivers/net/wireless/ath/ath9k/debug.h:201: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/net/wireless/ath/ath9k/debug.h:201: warning: ‘struct ath_txq’ declared inside parameter list
  CC [M]  drivers/net/wireless/ath/ath9k/eeprom.o
In file included from drivers/net/wireless/ath/ath9k/ath9k.h:28,
                 from drivers/net/wireless/ath/ath9k/eeprom.c:18:
drivers/net/wireless/ath/ath9k/debug.h:201: warning: ‘struct ath_buf’ declared inside parameter list
drivers/net/wireless/ath/ath9k/debug.h:201: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/net/wireless/ath/ath9k/debug.h:201: warning: ‘struct ath_txq’ declared inside parameter list
  CC [M]  drivers/net/wireless/ath/ath9k/mac.o
In file included from drivers/net/wireless/ath/ath9k/ath9k.h:28,
                 from drivers/net/wireless/ath/ath9k/mac.c:18:
drivers/net/wireless/ath/ath9k/debug.h:201: warning: ‘struct ath_buf’ declared inside parameter list
drivers/net/wireless/ath/ath9k/debug.h:201: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/net/wireless/ath/ath9k/debug.h:201: warning: ‘struct ath_txq’ declared inside parameter list
  CC [M]  drivers/net/wireless/ath/ath9k/calib.o
In file included from drivers/net/wireless/ath/ath9k/ath9k.h:28,
                 from drivers/net/wireless/ath/ath9k/calib.c:18:
drivers/net/wireless/ath/ath9k/debug.h:201: warning: ‘struct ath_buf’ declared inside parameter list
drivers/net/wireless/ath/ath9k/debug.h:201: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/net/wireless/ath/ath9k/debug.h:201: warning: ‘struct ath_txq’ declared inside parameter list
  CC [M]  drivers/net/wireless/ath/ath9k/ani.o
In file included from drivers/net/wireless/ath/ath9k/ath9k.h:28,
                 from drivers/net/wireless/ath/ath9k/ani.c:18:
drivers/net/wireless/ath/ath9k/debug.h:201: warning: ‘struct ath_buf’ declared inside parameter list
drivers/net/wireless/ath/ath9k/debug.h:201: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/net/wireless/ath/ath9k/debug.h:201: warning: ‘struct ath_txq’ declared inside parameter list
  CC [M]  drivers/net/wireless/ath/ath9k/phy.o
In file included from drivers/net/wireless/ath/ath9k/ath9k.h:28,
                 from drivers/net/wireless/ath/ath9k/phy.c:18:
drivers/net/wireless/ath/ath9k/debug.h:201: warning: ‘struct ath_buf’ declared inside parameter list
drivers/net/wireless/ath/ath9k/debug.h:201: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/net/wireless/ath/ath9k/debug.h:201: warning: ‘struct ath_txq’ declared inside parameter list
  CC [M]  drivers/net/wireless/ath/ath9k/beacon.o
In file included from drivers/net/wireless/ath/ath9k/ath9k.h:28,
                 from drivers/net/wireless/ath/ath9k/beacon.c:18:
drivers/net/wireless/ath/ath9k/debug.h:201: warning: ‘struct ath_buf’ declared inside parameter list
drivers/net/wireless/ath/ath9k/debug.h:201: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/net/wireless/ath/ath9k/debug.h:201: warning: ‘struct ath_txq’ declared inside parameter list
  CC [M]  drivers/net/wireless/ath/ath9k/main.o
In file included from drivers/net/wireless/ath/ath9k/ath9k.h:28,
                 from drivers/net/wireless/ath/ath9k/main.c:19:
drivers/net/wireless/ath/ath9k/debug.h:201: warning: ‘struct ath_buf’ declared inside parameter list
drivers/net/wireless/ath/ath9k/debug.h:201: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/net/wireless/ath/ath9k/debug.h:201: warning: ‘struct ath_txq’ declared inside parameter list
  CC [M]  drivers/net/wireless/ath/ath9k/recv.o
In file included from drivers/net/wireless/ath/ath9k/ath9k.h:28,
                 from drivers/net/wireless/ath/ath9k/recv.c:18:
drivers/net/wireless/ath/ath9k/debug.h:201: warning: ‘struct ath_buf’ declared inside parameter list
drivers/net/wireless/ath/ath9k/debug.h:201: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/net/wireless/ath/ath9k/debug.h:201: warning: ‘struct ath_txq’ declared inside parameter list
  CC [M]  drivers/net/wireless/ath/ath9k/xmit.o
In file included from drivers/net/wireless/ath/ath9k/ath9k.h:28,
                 from drivers/net/wireless/ath/ath9k/xmit.c:18:
drivers/net/wireless/ath/ath9k/debug.h:201: warning: ‘struct ath_buf’ declared inside parameter list
drivers/net/wireless/ath/ath9k/debug.h:201: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/net/wireless/ath/ath9k/debug.h:201: warning: ‘struct ath_txq’ declared inside parameter list
drivers/net/wireless/ath/ath9k/xmit.c: In function ‘ath_tx_complete_buf’:
drivers/net/wireless/ath/ath9k/xmit.c:1838: warning: passing argument 2 of ‘ath_debug_stat_tx’ from incompatible pointer type
drivers/net/wireless/ath/ath9k/debug.h:199: note: expected ‘struct ath_txq *’ but argument is of type ‘struct ath_txq *’
drivers/net/wireless/ath/ath9k/xmit.c:1838: warning: passing argument 3 of ‘ath_debug_stat_tx’ from incompatible pointer type
drivers/net/wireless/ath/ath9k/debug.h:199: note: expected ‘struct ath_buf *’ but argument is of type ‘struct ath_buf *’
  CC [M]  drivers/net/wireless/ath/ath9k/virtual.o
In file included from drivers/net/wireless/ath/ath9k/ath9k.h:28,
                 from drivers/net/wireless/ath/ath9k/virtual.c:18:
drivers/net/wireless/ath/ath9k/debug.h:201: warning: ‘struct ath_buf’ declared inside parameter list
drivers/net/wireless/ath/ath9k/debug.h:201: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/net/wireless/ath/ath9k/debug.h:201: warning: ‘struct ath_txq’ declared inside parameter list
  CC [M]  drivers/net/wireless/ath/ath9k/rc.o
In file included from drivers/net/wireless/ath/ath9k/ath9k.h:28,
                 from drivers/net/wireless/ath/ath9k/rc.c:19:
drivers/net/wireless/ath/ath9k/debug.h:201: warning: ‘struct ath_buf’ declared inside parameter list
drivers/net/wireless/ath/ath9k/debug.h:201: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/net/wireless/ath/ath9k/debug.h:201: warning: ‘struct ath_txq’ declared inside parameter list
  CC [M]  drivers/net/wireless/ath/ath9k/pci.o
In file included from drivers/net/wireless/ath/ath9k/ath9k.h:28,
                 from drivers/net/wireless/ath/ath9k/pci.c:20:
drivers/net/wireless/ath/ath9k/debug.h:201: warning: ‘struct ath_buf’ declared inside parameter list
drivers/net/wireless/ath/ath9k/debug.h:201: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/net/wireless/ath/ath9k/debug.h:201: warning: ‘struct ath_txq’ declared inside parameter list

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
