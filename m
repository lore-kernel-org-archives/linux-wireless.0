Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:45171 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757282Ab3BKNxV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 08:53:21 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.neratec.com (Postfix) with ESMTP id E5FA98B941F
	for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2013 14:53:17 +0100 (CET)
Received: from mail.neratec.com ([127.0.0.1])
	by localhost (mail.neratec.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id viD3rcD8EkIW for <linux-wireless@vger.kernel.org>;
	Mon, 11 Feb 2013 14:53:17 +0100 (CET)
Received: from [192.168.11.133] (CHB500181.neratec.local [192.168.11.133])
	by mail.neratec.com (Postfix) with ESMTPSA id A2E3B8B8556
	for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2013 14:53:17 +0100 (CET)
Message-ID: <5118F682.8000502@neratec.com> (sfid-20130211_145326_243072_B10AE6CB)
Date: Mon, 11 Feb 2013 14:47:46 +0100
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [BUG] Beacon loss event every second
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

   On latest testing and mac80211-next I am getting beacon loss event 
every second even when connection is perfect.

Feb 11 14:49:52 wlanTS kernel: [14148.599482] wlan0: cancelling probereq 
poll due to a received beacon
Feb 11 14:49:53 wlanTS kernel: [14149.565491] wlan0: detected beacon 
loss from AP - sending probe request
Feb 11 14:49:53 wlanTS kernel: [14149.578845] wlan0: cancelling probereq 
poll due to a received beacon
Feb 11 14:49:54 wlanTS kernel: [14150.561985] wlan0: detected beacon 
loss from AP - sending probe request
Feb 11 14:49:54 wlanTS kernel: [14150.588223] wlan0: cancelling probereq 
poll due to a received beacon
Feb 11 14:49:56 wlanTS kernel: [14152.554968] wlan0: detected beacon 
loss from AP - sending probe request
Feb 11 14:49:56 wlanTS kernel: [14152.578055] wlan0: cancelling probereq 
poll due to a received beacon
Feb 11 14:49:57 wlanTS kernel: [14153.551461] wlan0: detected beacon 
loss from AP - sending probe request
Feb 11 14:49:57 wlanTS kernel: [14153.556825] wlan0: cancelling probereq 
poll due to a received beacon
Feb 11 14:49:58 wlanTS kernel: [14154.595765] wlan0: detected beacon 
loss from AP - sending probe request
Feb 11 14:49:58 wlanTS kernel: [14154.597777] wlan0: cancelling probereq 
poll due to a received beacon

and so on...

Has somebody already fixed it? Just asking before I start digging in.

Br,
Wojtek

