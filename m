Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.224]:4364 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbYKZJMX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 04:12:23 -0500
Received: by rv-out-0506.google.com with SMTP id k40so378991rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2008 01:12:22 -0800 (PST)
Message-ID: <d9360e520811260112g4710460dj3159e3bfb22c88f4@mail.gmail.com> (sfid-20081126_101227_696611_6F074205)
Date: Wed, 26 Nov 2008 14:42:22 +0530
From: "Bharat Bhushan" <bharat.b.bhushan@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: bss _info_change query
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all
                   I suppose this api will be executed by open source
mac when it see any change in the bss info, and this might also serve
as an indication of various events like assoc/disassoc etc. i was just
walking through the code and found we are intimating assoc info in
ieee80211_associated but similar call is missing in
ieee80211_set_disassoc , although we are computing the various values
changes but there is no function call like
ieee80211_bss_info_change_notify.
Please  help  me whether i am missing anything or should we add a call
to ieee80211_bss_info_change_notify.

Thanks

bharat
