Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:55855 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665Ab2JXXFZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 19:05:25 -0400
Received: by mail-da0-f46.google.com with SMTP id n41so469391dak.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2012 16:05:24 -0700 (PDT)
Subject: Is Multi-Vif (vaps)  Different Channel Operation Supported?
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Kelly Hogan <kshogan@bluemesh.net>
In-Reply-To: <1351093332.10709.5.camel@jlt4.sipsolutions.net>
Date: Wed, 24 Oct 2012 17:05:21 -0600
Message-Id: <5DA0F03B-BA8C-4D9F-A9F1-0841D6774255@bluemesh.net> (sfid-20121025_010529_985869_96B4EE48)
References: <1351073603-11616-1-git-send-email-johannes@sipsolutions.net> <50880BD0.6080603@candelatech.com> <1351093332.10709.5.camel@jlt4.sipsolutions.net>
To: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

We are utilizing current ath9k and mac80211 and are trying to discern if multi-channel support is possible on different Vifs, on the same phy.

Example:  

Two Vifs running as masters, controlled via hostapd
One Vif running as a Station, controlled by wpa_supplicant
One Vif running as a mesh vap

We can run all the Vifs fine, but it appears that with shared hostapd/wpa_supplicant control files, that the master Vifs always have to follow the channel that the station is connected to.  The mesh vap also seems to require being on the same channel of the station.

Any info on if this is supported, or what order to process creation, channel setting, etc to get them to simultaneously allow different channel support would be helpful, or save us the time of assuming that it can be done if it in fact can't.

TIA!