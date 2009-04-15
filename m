Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60626 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752227AbZDOLTT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 07:19:19 -0400
Message-ID: <49E5C2A9.4050707@gmx.de> (sfid-20090415_131923_177061_E1F25CAA)
Date: Wed, 15 Apr 2009 13:19:05 +0200
From: ZeroBeat <ZeroBeat@gmx.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: SDIO_DEVICE_ID_MARVELL_8688WLAN not declared (snapshot 15.04.2009)
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Gentlemen.

gcc reports an error during the compilation:

compat-wireless-2009-04-15/drivers/net/wireless/libertas/if_sdio.c
ERROR 53:
=BBSDIO_DEVICE_ID_MARVELL_8688WLAN=AB
 not declared

My system:
UBUNTU 8.10
2.6.27-11-generic
gcc (Ubuntu 4.3.2-1ubuntu12) 4.3.2

compat-wireless works fine using the following adapters:
ALFA NETWORKS AWUS036H (RTL8187)
DELOCK 95800 (RT2561)
D-Link DWL-G650 AirPlus XTremeG Recv C1 (Atheros 5001X+)
D-Link DWL-G520 (Atheros 5212)
DIGITUS DN-7003GT  (RTL8187)


Best regards
Michael





--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
