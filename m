Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48125 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758523Ab1CDEUP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 23:20:15 -0500
Received: by fxm17 with SMTP id 17so1797129fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 20:20:13 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 4 Mar 2011 04:20:08 +0000
Message-ID: <AANLkTimaiWH4VC7czXxoXDDTzBo5MjWocgB7qbpo+bvR@mail.gmail.com>
Subject: mac80211_hwsim, hostap and wpa_supplicant
From: "Max R." <m.r650200@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I'm trying to simulate a little network with one ap and two stations
by using mac80211_hwsim, but I've been getting some problems. A little
time after creating the network, the stations get disconnected and the
kernel launches the following message: deauthenticated from
02:00:00:00:*:00 (Reason: 2). It looks like a problem related to
timeout expired.

This is the script that is executed to make the network:
http://paste.ideaslabs.com/show/45UUoXz6iq
This one is the wpa_supplicant configuration file:
http://paste.ideaslabs.com/show/5wXyqXRVM
And finally the hostap.conf: http://paste.ideaslabs.com/show/NkAHZTqstT

Thanks in advance :)

-- 
Max R.
