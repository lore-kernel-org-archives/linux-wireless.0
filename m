Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2425 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608Ab3BVJHw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 04:07:52 -0500
From: "Piotr Haber" <phaber@broadcom.com>
To: linux-wireless@vger.kernel.org, phaber@broadcom.com
Subject: [RFC 0/2] control Bluetooth coexistence
Date: Fri, 22 Feb 2013 10:08:10 +0100
Message-ID: <1361524092-4814-1-git-send-email-phaber@broadcom.com> (sfid-20130222_100758_622930_356B74D2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As 802.11 and Bluetooth devices can interfere with each other
several coexistence techniques exist. 
This is particularly important for devices that share antenna
and analog front end between Wifi and Bluetooth.
There are situations when software control over the coexistence
algorithm behavior would be beneficial - ex. giving EAPOL handshake
or DHCP negotiation high priority.

This two patches add possibility to control Wifi-Bluetooth coexistence mode.
First one extends wiphy params with coexistence mode setting.
Second one implements coexistence control for brcmfmac.

[RFC] cfg80211: configuration of Bluetooth coexistence mode
brcmfmac: control BT coexistence parameters

-- 
1.7.9.5


