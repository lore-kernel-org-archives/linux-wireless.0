Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:10575 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191AbZJLLLm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 07:11:42 -0400
Received: by fg-out-1718.google.com with SMTP id 16so411022fgg.1
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2009 04:09:54 -0700 (PDT)
From: Florian Fainelli <florian@openwrt.org>
To: Riffer <riffer@penny.prima.de>
Subject: Re: Bleeding Edge does not compile (was Re: Bleeding Edge b43 dated since 30 of september no
 =?utf-8?q?longer=09working_=26_today_does_not_even?= compile.)
Date: Mon, 12 Oct 2009 13:09:47 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <4ACB91E7.5010405@penny.prima.de> <20091006211102.GC2911@tuxdriver.com> <4ACCDF24.7050002@penny.prima.de>
In-Reply-To: <4ACCDF24.7050002@penny.prima.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200910121309.47401.florian@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wednesday 07 October 2009 20:34:12 Riffer wrote:
> Hello!
>
> Thanks for your reply!
>
> Besides the other failure mentioned after patching the version of 06th
> there is a new problem with the one from today (7th of oct):
>
> ----
> /home/riffer/bleeding/compat-wireless-2009-10-07/drivers/net/wireless/ath/a
>th5k/base.c: In Funktion »ath5k_pci_suspend_compat«:
> /home/riffer/bleeding/compat-wireless-2009-10-07/drivers/net/wireless/ath/a
>th5k/base.c:206: Fehler: Inkompatibler Typ für Argument 1 von
> »ath5k_pci_suspend«
> /home/riffer/bleeding/compat-wireless-2009-10-07/drivers/net/wireless/ath/a
>th5k/base.c: In Funktion »ath5k_pci_resume_compat«:
> /home/riffer/bleeding/compat-wireless-2009-10-07/drivers/net/wireless/ath/a
>th5k/base.c:224: Fehler: Inkompatibler Typ für Argument 1 von
> »ath5k_pci_resume«
> make[5]: ***
> [/home/riffer/bleeding/compat-wireless-2009-10-07/drivers/net/wireless/ath/
>ath5k/base.o] Fehler 1
> make[4]: ***
> [/home/riffer/bleeding/compat-wireless-2009-10-07/drivers/net/wireless/ath/
>ath5k] Fehler 2
> make[3]: ***
> [/home/riffer/bleeding/compat-wireless-2009-10-07/drivers/net/wireless/ath]
> Fehler 2
> make[2]: ***
> [/home/riffer/bleeding/compat-wireless-2009-10-07/drivers/net/wireless]
> Fehler 2
> make[1]: *** [_module_/home/riffer/bleeding/compat-wireless-2009-10-07]
> Fehler 2
> make[1]: Verlasse Verzeichnis
> '/usr/src/linux-headers-2.6.30-02063006-generic'
> make: *** [modules] Fehler 2

I got the same compilation failure here, the code in ath5k/base.c looks 
perfectly fine though.
