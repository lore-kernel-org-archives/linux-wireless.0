Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:39779 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab1EZIJq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2011 04:09:46 -0400
Received: from [82.94.249.234] (latitanza [82.94.249.234]) (Authenticated sender: ordex@autistici.org) by localhost (Postfix) with ESMTPSA id C55D89830D
	for <linux-wireless@vger.kernel.org>; Thu, 26 May 2011 07:49:59 +0000 (UTC)
Date: Thu, 26 May 2011 09:50:04 +0200
From: Antonio Quartulli <ordex@ritirata.org>
To: linux-wireless@vger.kernel.org
Subject: ieee80211_ptr and pre-cfg80211 drivers
Message-ID: <20110526075004.GC28174@ritirata.org> (sfid-20110526_100950_078653_800E96D3)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hell everyone,

I'm currenctly writing a little program that have to do some stuff with
a wireless card. Actually I need to understand whether a struct
net_device is associated to a wireless card or not.

Someone suggested me to check for net_device->ieee80211_ptr != NULL.
If so, I can assume the device is a wireless card. But can I also assume
the opposite? I mean, if ieee80211_ptr == NULL can I be sure the device
is not wireless?

Digging into the kernel code it seems to me that pre-cfg80211 drivers
doesn't handle such field.

Do you have any suggestion how I can solve this problem?

Thank you.

Regards,

-- 
Antonio Quartulli

..each of us alone is worth nothing..
Ernesto "Che" Guevara
