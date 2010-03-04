Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f181.google.com ([209.85.216.181]:36119 "EHLO
	mail-px0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab0CDAn6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 19:43:58 -0500
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 3 Mar 2010 16:43:37 -0800
Message-ID: <43e72e891003031643u353c72dcj23bf429363a16ec8@mail.gmail.com>
Subject: Linux Bluetooth Coexistence documentation in general and for ath9k
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linux-bluetooth <linux-bluetooth@vger.kernel.org>,
	linux-kernel@vger.kernel.org,
	"Kevin Hayes\" <kevin@atheros.com>, \"Dan Tian\""
	<Dan.Tian@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marcel, a question for you below.

The question of Bluetooth coexistence pops up here, on IRC and on bug
reports quite too often so I've stuffed what I could onto a page with
a few references / code and about ath9k's schemes for BT coexistence,
feel free to extend or correct:

http://wireless.kernel.org/en/users/Documentation/Bluetooth-coexistence
http://wireless.kernel.org/en/users/Drivers/ath9k/btcoex

I'm still not sure if "2-wire" and "3-wire" are generic terms and if
someone owns a trademark on them or what, but looking down the road I
think it would be nice to export this information through nl80211, if
a device supports any of these BT-coex schemes and if so, perhaps
display the current signal status of:

  * WLAN_ACTIVE
  * BT_PRIORITY
  * BT_STATE

I do wonder if this could be useful to network applets like network
manager/connman. The other BT coex schemes are BT specific it seems
and not sure if those devices can expose that information out and
inform userspace of certain events.

Marcel, does the BlueZ support exporting if certain bt-coex schemes
are supported like AFH, channel skipping, TDM, and also if they are
being used and details of that?

  Luis
