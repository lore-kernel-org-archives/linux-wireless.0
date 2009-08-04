Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s26.blu0.hotmail.com ([65.55.111.101]:45769 "EHLO
	blu0-omc2-s26.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755425AbZHDMim convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 08:38:42 -0400
Message-ID: <BLU134-W8EEC7C3FE7F910BCD41E5CC0C0@phx.gbl>
From: sawant paresh <sawantparesh@hotmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: support for pmkid candidate list and roaming
Date: Tue, 4 Aug 2009 18:08:43 +0530
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

I want to know if mac80211 subsystem supports following -

1.
Given that the user space station application is connected to some AP
with SSID, and there is another AP with same SSID around in the radio
range, then does mac80211 subsystem be able to send an event
notification to user space?


2. Can mac80211 subsystem perform dissociate with current AP due to
weak signal and connect to another with same SSID and better signal
strength, and let the user space know about the new association?


Thanks

- Paresh
_________________________________________________________________
One stop at MSN India to catch up with what’s hot in the world around you today
http://in.msn.com