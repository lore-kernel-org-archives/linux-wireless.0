Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:40620 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580AbZDVQxD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 12:53:03 -0400
Subject: Using wpa_supplicant in D-Bus mode with nl80211 driver
From: Marcel Holtmann <marcel@holtmann.org>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Wed, 22 Apr 2009 17:52:57 +0100
Message-Id: <1240419177.12282.3.camel@localhost.localdomain> (sfid-20090422_185343_442395_36D13F5A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni,

I am trying to use wpa_supplicant in D-Bus mode with the nl80211 driver
instead of WEXT. I don't seem to be able to control the from the command
line and the -D option doesn't take.

Providing DBus service 'fi.epitest.hostap.WPASupplicant'.
Initializing interface 'wlan0' conf 'N/A' driver 'default' ctrl_interface 'N/A' bridge 'N/A'
Interface wlan0 set UP - waiting a second for the driver to complete initialization
SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
  capabilities: key_mgmt 0xf enc 0xf flags 0x0

Can we fix this somehow? I really wanna get rid of using WEXT.

Regards

Marcel


