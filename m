Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rzcomm12.rz.tu-bs.de ([134.169.9.59]:58962 "EHLO
	rzcomm12.rz.tu-bs.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbXDDNdb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2007 09:33:31 -0400
Received: from [134.169.64.140] (imt12.imt.ing.tu-bs.de [134.169.64.140])
	by rzcomm12.rz.tu-bs.de (8.11.1/8.11.1) with ESMTP id l34DEHG06594
	for <linux-wireless@vger.kernel.org>; Wed, 4 Apr 2007 15:14:17 +0200 (METDST)
Message-ID: <4613A4A9.1060902@l4x.org>
Date: Wed, 04 Apr 2007 15:14:17 +0200
From: Jan Dittmer <jdi@l4x.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Orinoco, mac80211 and wpa2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I've a 802.11b Orinoco based integrated WLAN card in my
Sony Laptop (SRX51P). I'm using it with the in kernel 'orinoco-cs'
driver. The driver does not support connecting to wpa2
enabled networks. If I understand it correctly, the mac80211
can emulate wpa2 in software? Would porting the orinoco
driver to the new framework make it to possible to use wpa2
with it? Or is wpa2 hardware dependent?

Thanks,

Jan
