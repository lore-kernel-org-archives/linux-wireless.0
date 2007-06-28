Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3.infineon.com ([203.126.106.229]:39733 "EHLO
	smtp3.infineon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762645AbXF1IkZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2007 04:40:25 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: ieee80211_rx_mgmt: pushing fake 'management' frames intouserspace
Date: Thu, 28 Jun 2007 16:40:21 +0800
Message-ID: <A2CE5E0A70B68046A98EB5145552E2770119C773@sinse303.ap.infineon.com>
In-Reply-To: <1182952910.4769.20.camel@johannes.berg>
References: <A2CE5E0A70B68046A98EB5145552E27701173B8F@sinse303.ap.infineon.com> <1182952910.4769.20.camel@johannes.berg>
From: <Mandy.Peng@infineon.com>
To: <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>-----Original Message-----
>From: Johannes Berg [mailto:johannes@sipsolutions.net] 
>Sent: Wednesday, June 27, 2007 10:02 PM
>To: Peng Mandy (IFTW COM AC SE)
>Cc: linux-wireless@vger.kernel.org
>Subject: Re: ieee80211_rx_mgmt: pushing fake 'management' frames
intouserspace
>
>Also, I thought you were doing a fullmac chipset? Then you shouldn't be
worrying about mac80211 *at all*
>
>johannes

Yes, I have to worry about it. Since our chipset only handle the data
path task, the host software has to take care of all the management
tasks. If we write a netdevice driver and register to cfg80211. Then we
should use the similar way to pass through the management frame as
mac80211. So I wondering how do you testing the mac80211 management
action ? Which version of hostapd and wpa_supplicant are you used to
verify the mac80211 ? We will set up the set environment.

Mandy.
