Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:29165 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbXCaJgQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Mar 2007 05:36:16 -0400
Received: by ug-out-1314.google.com with SMTP id 44so1044719uga
        for <linux-wireless@vger.kernel.org>; Sat, 31 Mar 2007 02:36:15 -0700 (PDT)
Message-ID: <460E2B8C.4030002@gmail.com>
Date: Sat, 31 Mar 2007 11:36:12 +0200
From: dragoran <drago01@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: mac80211 does not support WPA when used with wext
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello
While testing the iwlwifi driver I noticed that the mac80211 does 
provide a wext interface but does not support wpa with it.
Why? Is this a known bug/limitation.
And if yes any plans to fix it? Fedora 7 uses mac80211 by default which 
results into networkmanager and (unpatched)wpa_supplicant is useless for 
people who use WPA/WPA2.

P.S: please CC me
