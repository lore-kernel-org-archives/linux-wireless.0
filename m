Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ted.prima.de ([83.97.48.3]:42541 "EHLO ted.prima.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757640AbZJGSgj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2009 14:36:39 -0400
Message-ID: <4ACCDF24.7050002@penny.prima.de>
Date: Wed, 07 Oct 2009 20:34:12 +0200
From: Riffer <riffer@penny.prima.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Bleeding Edge does not compile (was Re: Bleeding Edge b43 dated since
 30 of september no longer	working & today does not even compile.)
References: <4ACB91E7.5010405@penny.prima.de> <20091006211102.GC2911@tuxdriver.com>
In-Reply-To: <20091006211102.GC2911@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

Thanks for your reply!

Besides the other failure mentioned after patching the version of 06th
there is a new problem with the one from today (7th of oct):

----
/home/riffer/bleeding/compat-wireless-2009-10-07/drivers/net/wireless/ath/ath5k/base.c:
In Funktion »ath5k_pci_suspend_compat«:
/home/riffer/bleeding/compat-wireless-2009-10-07/drivers/net/wireless/ath/ath5k/base.c:206:
Fehler: Inkompatibler Typ für Argument 1 von »ath5k_pci_suspend«
/home/riffer/bleeding/compat-wireless-2009-10-07/drivers/net/wireless/ath/ath5k/base.c:
In Funktion »ath5k_pci_resume_compat«:
/home/riffer/bleeding/compat-wireless-2009-10-07/drivers/net/wireless/ath/ath5k/base.c:224:
Fehler: Inkompatibler Typ für Argument 1 von »ath5k_pci_resume«
make[5]: ***
[/home/riffer/bleeding/compat-wireless-2009-10-07/drivers/net/wireless/ath/ath5k/base.o]
Fehler 1
make[4]: ***
[/home/riffer/bleeding/compat-wireless-2009-10-07/drivers/net/wireless/ath/ath5k]
Fehler 2
make[3]: ***
[/home/riffer/bleeding/compat-wireless-2009-10-07/drivers/net/wireless/ath]
Fehler 2
make[2]: ***
[/home/riffer/bleeding/compat-wireless-2009-10-07/drivers/net/wireless]
Fehler 2
make[1]: *** [_module_/home/riffer/bleeding/compat-wireless-2009-10-07]
Fehler 2
make[1]: Verlasse Verzeichnis
'/usr/src/linux-headers-2.6.30-02063006-generic'
make: *** [modules] Fehler 2

----

-- 
Best regards,
Riffer
