Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:47030 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765709AbXJZWBS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 18:01:18 -0400
Received: from [99.236.101.138] (helo=crashcourse.ca)
	by astoria.ccjclearline.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <rpjday@crashcourse.ca>)
	id 1IlTr5-0002fU-Mi
	for linux-wireless@vger.kernel.org; Fri, 26 Oct 2007 14:24:23 -0400
Date: Fri, 26 Oct 2007 14:21:30 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
To: linux-wireless@vger.kernel.org
Subject: some apparently unreferenced CONFIG variables
Message-ID: <Pine.LNX.4.64.0710261420280.3111@localhost.localdomain> (sfid-20071026_230121_983075_9A737992)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>>>>> B43_DMA_MODE
drivers/net/wireless/b43/Kconfig:110:config B43_DMA_MODE
>>>>> B43LEGACY_DMA_MODE
drivers/net/wireless/b43legacy/Kconfig:70:config B43LEGACY_DMA_MODE
>>>>> B43LEGACY_PCI_AUTOSELECT
drivers/net/wireless/b43legacy/Kconfig:24:config B43LEGACY_PCI_AUTOSELECT
>>>>> B43LEGACY_PCICORE_AUTOSELECT
drivers/net/wireless/b43legacy/Kconfig:31:config B43LEGACY_PCICORE_AUTOSELECT
>>>>> B43LEGACY_PIO_MODE
drivers/net/wireless/b43legacy/Kconfig:77:config B43LEGACY_PIO_MODE
>>>>> B43_PCI_AUTOSELECT
drivers/net/wireless/b43/Kconfig:31:config B43_PCI_AUTOSELECT
>>>>> B43_PCICORE_AUTOSELECT
drivers/net/wireless/b43/Kconfig:38:config B43_PCICORE_AUTOSELECT
>>>>> B43_PIO_MODE
drivers/net/wireless/b43/Kconfig:117:config B43_PIO_MODE

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
