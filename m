Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:42196 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177Ab2GCMrr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 08:47:47 -0400
From: <Piotr.Nakraszewicz@tieto.com>
To: <linux-wireless@vger.kernel.org>
CC: <filip.matusiak@tieto.com>, <mcgrof@gmail.com>,
	<pstew@chromium.org>
Date: Tue, 3 Jul 2012 15:47:44 +0300
Subject: wlan automated tests
Message-ID: <E50901D4F2CF69428D43141B7C85867929E154AE7B@EXMB03.eu.tieto.com> (sfid-20120703_144755_333640_EC1CCA88)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

What is the current status of wlan automated tests?

I found 3 started projects:

1. wifi-test:
http://wireless.kernel.org/en/developers/Testing/wifi-test
But it looks dead. Last commit is from 2010.

2. LTP:
http://thread.gmane.org/gmane.linux.kernel.wireless.general/19759
http://thread.gmane.org/gmane.linux.ltp/7884

The last comment I found was from 2009 from Luis R. Rodriguez:
"The GSoC student fell off from the face of the earth without even notice so the project was never finished. The project is up for grabs for anyone now to implement."

Is that still valid?

3. Chromium Wifi tests:
http://thread.gmane.org/gmane.linux.kernel.wireless.general/57576

The problem is they are designed to test chromium OS so it looks like they can't be used for purpose described here:
https://wiki.linuxfoundation.org/en/Google_Summer_of_Code_2009#Automation_of_testing_using_mac80211_hwsim_and_Orbit
"Ideally we'd like to see automated tests run weekly to ensure there are no regressions for basic functionality. To test mac80211 and cfg80211 we can use and advance mac80211_hwsim as required without the need to actually use hardware."


I'm planning to use and extend one of these projects and I'd like to know which one is preferable.
Any hints?

Pozdrawiam / Best regards,
Piotr


