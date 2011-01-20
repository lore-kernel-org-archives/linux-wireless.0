Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51834 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab1ATShl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 13:37:41 -0500
Received: by iwn9 with SMTP id 9so845125iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 10:37:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110120183210.13527.33808@he.sipsolutions.net>
References: <20110120183210.13527.33808@he.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 20 Jan 2011 10:37:20 -0800
Message-ID: <AANLkTi=EDRimawaentk_ppcrsTf1Rex7H9QJspktaa3C@mail.gmail.com>
Subject: Fwd: [Linux Wireless] Update of "en/users/Drivers/carl9170" by PaulFertser
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Paul Fertser <fercerpav@gmail.com>,
	Christian Lamparter <chunkeey@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Huh?


---------- Forwarded message ----------
From: Linux Wireless <johannes@sipsolutions.net>
Date: Thu, Jan 20, 2011 at 10:32 AM
Subject: [Linux Wireless] Update of "en/users/Drivers/carl9170" by PaulFertser
To: Linux Wireless <johannes@sipsolutions.net>


Dear Wiki user,

You have subscribed to a wiki page or wiki category on "Linux
Wireless" for change notification.

The "en/users/Drivers/carl9170" page has been changed by PaulFertser:
http://linuxwireless.org/en/users/Drivers/carl9170?action=diff&rev1=17&rev2=18

Comment:
Information about QoS^AMPDU and WOL support

 == 802.11n Compatibility ==

 It's worth mentioning that the chip was designed, produced and sold
in the early 802.11n-draft period.
- Compatibility will always be an issue.
+ Compatibility will always be an issue.
+
+ A [[http://git.kernel.org/?p=linux/kernel/git/chr/carl9170fw.git;a=commitdiff;h=39be7dc384e0dd45dc36b4b517fd9fae874b06f0|known
problem]] is that hardware can not support
+ [[http://en.wikipedia.org/wiki/IEEE_802.11n-2009#Frame_aggregation|frame
+ aggregation]] and
+ [[QoS|http://en.wikipedia.org/wiki/Wireless_Multimedia_Extensions]] at
+ the same time, meaning the device is not suitable for any serious
+ 802.11n setup.

 ||Hardware||||Problem||||Solution?||
 ||'''BCM4313'''||||''Hardware incompatibility''||||''replace hardware''||
@@ -70, +77 @@

  * Input device for WPS button event (depending on hardware)
  * automatic recovery from several fatal events
  * Regulatory domain restrictions
+  * [[http://git.kernel.org/?p=linux/kernel/git/chr/carl9170fw.git;a=commit;h=6476369c2c6d4ba487408cb5daff8df0480d6b4a|Wake-on-LAN
+  support]] (can resume your system from suspend-to-ram)

 == not working yet ==
  * Power Save Mode, It's implemented but buggy
