Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4.int-evry.fr ([157.159.10.71]:57733 "EHLO
	smtp4.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758315AbYLDALA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2008 19:11:00 -0500
Received: from smtp2.int-evry.fr (smtp2.int-evry.fr [157.159.10.45])
	by smtp4.int-evry.fr (Postfix) with ESMTP id 23C32FE2D27
	for <linux-wireless@vger.kernel.org>; Thu,  4 Dec 2008 01:10:58 +0100 (CET)
Message-ID: <49371FE4.2050507@telecom-sudparis.eu> (sfid-20081204_011110_497010_01340303)
Date: Thu, 04 Dec 2008 01:10:12 +0100
From: Chanthearith HUON <chanthearith.huon@telecom-sudparis.eu>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Hakima.Chaouchi@it-sudparis.eu
Subject: failed to create interface: -1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everyone,

# iw dev wlan0 interface add mesh type mp mesh_id 10
failed to create interface: -1

I searched the web and read the archives but that did not help.

Any ideas of what went wrong?

Environment:
Distribution: ubuntu 8.10 Intrepid Ibex with kernel 2.6.27
Wireless card: Linksys wmp54g pci with ssb driver (there should be no 
problem as listed in http://linuxwireless.org/en/users/Devices/PCI)

Thanks,
Thierry


