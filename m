Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rol.ru ([194.67.1.9]:11805 "EHLO smtp.rol.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbZGANnT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 09:43:19 -0400
Received: from pontus.sovam.com ([194.67.3.4]:5422 "EHLO [194.67.3.4]"
	smtp-auth: <none> TLS-CIPHER: <none> TLS-PEER-CN1: <none>
	rhost-flags-OK-OK-OK-FAIL) by gnome04.net.rol.ru with ESMTP
	id S5390917AbZGANfk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 17:35:40 +0400
Message-ID: <4A4B662C.2070200@rol.ru>
Date: Wed, 01 Jul 2009 17:35:40 +0400
From: Kirill Berezin <kyb22@rol.ru>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Multiple BSSID status.
Content-Type: text/plain; charset=KOI8-R; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hie ALL!

I would like to know a currents status of multiple BSSID support for 
atheros and broadcom chips. I found parts responsible for for mac group 
handling in ath5k/9k drivers.

And the second question is what part of a system is responsible for 
sending beacons with different SSID (driver or a higher level program, 
say hostapd)?
 
I am trying to configure openwrt based wireless router (I have an asus 
wl-500g deluxe) with multiple SSID, each with own BSSID and VLAN. It 
looks like current version of hostapd supports multiple BSSID with 
hiddent SSID, but it fails to UP  interfaces for mac80211 (br43).

Kirill.

-- 
Кирилл Березин <kyb22@rol.ru>
Старший инженер-программист
Группа развития ISP систем, Совинтел
Группа Компаний ВымпелКом

