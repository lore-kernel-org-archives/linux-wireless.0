Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:44630
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbXJZXxf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 19:53:35 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: some apparently unreferenced CONFIG variables
Date: Sat, 27 Oct 2007 01:52:31 +0200
Cc: linux-wireless@vger.kernel.org
References: <Pine.LNX.4.64.0710261420280.3111@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0710261420280.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710270152.31290.mb@bu3sch.de> (sfid-20071027_005338_279200_F81A2FC0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 26 October 2007 20:21:30 Robert P. J. Day wrote:
> 
> >>>>> B43_DMA_MODE
> drivers/net/wireless/b43/Kconfig:110:config B43_DMA_MODE
> >>>>> B43LEGACY_DMA_MODE
> drivers/net/wireless/b43legacy/Kconfig:70:config B43LEGACY_DMA_MODE
> >>>>> B43LEGACY_PCI_AUTOSELECT
> drivers/net/wireless/b43legacy/Kconfig:24:config B43LEGACY_PCI_AUTOSELECT
> >>>>> B43LEGACY_PCICORE_AUTOSELECT
> drivers/net/wireless/b43legacy/Kconfig:31:config B43LEGACY_PCICORE_AUTOSELECT
> >>>>> B43LEGACY_PIO_MODE
> drivers/net/wireless/b43legacy/Kconfig:77:config B43LEGACY_PIO_MODE
> >>>>> B43_PCI_AUTOSELECT
> drivers/net/wireless/b43/Kconfig:31:config B43_PCI_AUTOSELECT
> >>>>> B43_PCICORE_AUTOSELECT
> drivers/net/wireless/b43/Kconfig:38:config B43_PCICORE_AUTOSELECT
> >>>>> B43_PIO_MODE
> drivers/net/wireless/b43/Kconfig:117:config B43_PIO_MODE
> 
> rday
> 

I suggest you fix your script that found all these false positives for you.

-- 
Greetings Michael.
