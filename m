Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [68.230.241.172] ([68.230.241.172]:43417 "EHLO
	fed1rmwml304.cox.net" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbbCVSGf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2015 14:06:35 -0400
Received: from fed1rmimpo306 ([68.230.241.174]) by fed1rmfepo201.cox.net
          (InterMail vM.8.01.05.15 201-2260-151-145-20131218) with ESMTP
          id <20150322175715.MFPW30340.fed1rmfepo201.cox.net@fed1rmimpo306>
          for <linux-wireless@vger.kernel.org>;
          Sun, 22 Mar 2015 13:57:15 -0400
Message-ID: <20150322135714.32R0O.140556.imail@fed1rmwml206> (sfid-20150322_190639_328598_27855F3B)
Date: Sun, 22 Mar 2015 10:57:14 -0700
From: Conrad Lara <ipstealer@cox.net>
To: linux-wireless@vger.kernel.org
Subject: CRDA/REGDB and 802.11 devices with a frequency offset (transverted
 onboard)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All,

I've been working with hardware that is essentially ATH9k 802.11n gear that in order to maintain the manufactures investment in designing is basically a stock previous design with a transverter in the frontend (Ubuiqiti) the 900mhz devices are 2.4Ghz devices up/down converted to 900, and the 3.4/3.6GHz devices are 5.8GHz devices up/down converted.

Has any thought been given to handling these sort of situations in the context of setting the radios and maintaining a REGDB compliance?

Ideally the manufacture would of just used the chip and called it directly to the frequencies in the correct band, but that would of limited the ability to mass produce under compatibility as the devices as are register just like a regular 2.4/6.8GHz device and the OS doesn't know any better so the choice appears to have been made in many cases to just transvert after the chip api.

I am not sure I can see any method that would universally work without having the ability to inject a user choice or into the subject which is probably a significant hurdle to maintaining regdb compliance, however the other alternative is also just as grim, forcing the publishing of wide-open REGDB tables to handle these devices. 

A middle ground may be an API in the middle that permits a re-mapping of frequency based on hardware ID's (Hopefully every single device has a unique ID, so far all the hardware I have hit has changed the ID for a band change) 

Any input on what discussion (as I am having trouble locating any) may have come up on this subject would be appreciated.

Please include my direct email either in TO or CC field. 

Regards,
Conrad Lara

