Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.lenbrook.com ([216.94.44.85]:26660 "EHLO mail.lenbrook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754094Ab2AMWSi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jan 2012 17:18:38 -0500
Message-ID: <4F10AA2D.1060000@lenbrook.com> (sfid-20120113_231842_337504_FAC1D175)
Date: Fri, 13 Jan 2012 17:03:25 -0500
From: Jonathan Bagg <jbagg@lenbrook.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ath6kl in compat wireless supports AP mode?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Anybody know if the ath6kl driver in compat wireless supports AP mode?

hostapd hostapd.conf
nl80211: Failed to set interface wlan0 into AP mode
nl80211 driver initialization failed.

hostapd.conf
interface=wlan0
driver=nl80211
ssid=test
channel=1

Using
hostapd v0.7.3
libnl-2.0

Jon Bagg


