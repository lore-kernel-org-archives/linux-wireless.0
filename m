Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44745 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab2ENIKF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 04:10:05 -0400
Received: by obbtb18 with SMTP id tb18so7098817obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2012 01:10:04 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 14 May 2012 10:10:04 +0200
Message-ID: <CAOpc7mHADqRcvXgg-8JoVfsoDh0_cZnkqBFS3AadwS6x0gtg7g@mail.gmail.com> (sfid-20120514_101010_891845_2010FFCE)
Subject: [BUG, ath9k]: NUL bytes at end of /sys/kernel/debug/ieee80211/phy0/ath9k/modal_eeprom
From: Holger Schurig <holgerschurig@googlemail.com>
To: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At first I wondered why "grep -i ant ." in this phy0/ath9k directory
just said "Binary file modal_eeprom matches". But when I used "less
modal_eeprom", I saw a bunch of NUL bytes at the end of the virtual
file.

-- 
http://www.holgerschurig.de
