Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3.infineon.com ([203.126.106.229]:4777 "EHLO
	smtp3.infineon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbXF0NZo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2007 09:25:44 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: ieee80211_rx_mgmt: pushing fake 'management' frames into userspace
Date: Wed, 27 Jun 2007 21:25:41 +0800
Message-ID: <A2CE5E0A70B68046A98EB5145552E27701173B8F@sinse303.ap.infineon.com>
From: <Mandy.Peng@infineon.com>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have a problem about the relation between mac80211, hostap and
hostapd. In the ieee80211_rx_mgmt( ), it pushes a fake 'management'
frames into userspace via protocol ETH_P_802_2. May I ask which program
will receive this packet to handling management message ? Where can I
find the suitable userspace management program to work with current
mac80211 ? 

Thanks.

Mandy.
