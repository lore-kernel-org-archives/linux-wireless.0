Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:63101 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbYFUJzM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jun 2008 05:55:12 -0400
Subject: building mac80211
From: John George Wright <john@limongrafica.com>
Reply-To: john@limongrafica.com
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Sat, 21 Jun 2008 10:54:57 +0100
Message-Id: <1214042097.12100.5.camel@Johnardbell> (sfid-20080621_115542_234816_AB30CAFB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm very new to the linux operating systems so please treat me as a
child.

I have an Intel PRO/Wireless 3945ABG built into my laptop and I am
trying to adapt the latest version of ubuntu to work with it. I followed
some online instructions and downloaded the mac80211-10.0.4 tar,
unpacked it and used this command:

make SHELL=/bin/bash

but received the following error:

Building modified version in 'modified/' directory:
Copying modified/ from origin/...done
Applying patches and scripts from pending/.
 + Applying: pending/0001-mac80211-Add-basic-IEEE-802.11n-support.patch
	From 26e77a5fef845edcb5c27db52f413e7558db0e20 Mon Sep 17 00:00:00 2001
scripts/generate_modified: line 57: patch: command not found
-----patch failure output-----

pending/0001-mac80211-Add-basic-IEEE-802.11n-support.patch failed.
Terminating.
If patch or script failed, check pre/ and post/ for current stage.
make: *** [modified] Error 1

Would you have any idea where I'm going wrong?

Thanks,
John

