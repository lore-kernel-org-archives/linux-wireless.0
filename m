Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:65267 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268AbXEBIe6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2007 04:34:58 -0400
Received: by ug-out-1314.google.com with SMTP id 44so206060uga
        for <linux-wireless@vger.kernel.org>; Wed, 02 May 2007 01:34:57 -0700 (PDT)
Message-ID: <46384D34.9080505@gmail.com>
Date: Wed, 02 May 2007 10:35:00 +0200
From: dragoran <drago01@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: mac80211 and signal strength reporting
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
while testing iwlwifi (which works fine now btw) I noticed that the 
signal strenght reporting when using mac80211 is broken:
iwconfig only show dBm value....
gnome-netstatus always shows 0%
networkmanager always shows 100%
whats going on? does some has any idea?
is this a known bug or is iwlwifi the culprit?

P.S:
please CC me

