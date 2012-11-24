Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37469 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab2KXXOs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2012 18:14:48 -0500
Date: Sat, 24 Nov 2012 15:14:38 -0800
From: Jonathan Nieder <jrnieder@gmail.com>
To: stable@vger.kernel.org
Cc: Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Touko Korpela <touko.korpela@iki.fi>,
	linux-wireless@vger.kernel.org
Subject: [3.2.y] Re: [PATCH 2/2] brcm80211: smac: only print block-ack
 timeout message at trace level
Message-ID: <20121124231438.GA26176@elie.Belkin> (sfid-20121125_001458_795608_7D45F7FA)
References: <1330018703-2472-1-git-send-email-arend@broadcom.com>
 <1330018703-2472-3-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1330018703-2472-3-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

Please consider

  2b0a53d51b5f brcm80211: smac: only print block-ack timeout message
               at trace level

for application to the 3.2.y tree.

It just lowers the priority of a distracting repeated message about a
normal condition:

  ieee80211 phy0: AMPDU status: BA Timeout, seq 152, in_transit 0

See <http://bugs.debian.org/674430> for context.

The patch was applied upstream during the 3.3-rc7 cycle.  Applying it
should make debugging other problems easier.  Thoughts of all kinds
welcome, as always.

Regards,
Jonathan
