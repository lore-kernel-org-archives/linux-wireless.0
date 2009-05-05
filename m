Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f224.google.com ([209.85.219.224]:35734 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbZEEE5s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 00:57:48 -0400
Received: by ewy24 with SMTP id 24so4622190ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 04 May 2009 21:57:48 -0700 (PDT)
Subject: [BUG] Connection to an access point is dropped shortly after a
 association
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 05 May 2009 07:57:44 +0300
Message-Id: <1241499464.4816.13.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a recent regression.
For some access points, eg @ my home, everything is fine as before.
But here @ university (open access points) this happens.

Looking at output of 'iw dev wlan 0 station dump' reveals very large
'inactive time'.

Reconnecting restores the connection briefly for yet another 30 seconds
or so.

Best regards,
	Maxim Levitsky

PS: this is iwlwifi.git commit:
5a94b6d38100b7056a5a347e5c51359d924d305d



