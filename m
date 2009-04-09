Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:62849 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936564AbZDIQt2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2009 12:49:28 -0400
Received: by fxm2 with SMTP id 2so681929fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 09 Apr 2009 09:49:25 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 9 Apr 2009 18:49:25 +0200
Message-ID: <f6ca9fed0904090949x2c724e89i655ebb698f0c72d5@mail.gmail.com> (sfid-20090409_184934_312743_8CB286E8)
Subject: ath9k slow throughput when acciotated with wrt54gl
From: drago01 <drago01@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I experience weird throughput issues with my DLINK DWA-547 pci card.

It seems to be capped to ~2MBit/s when transferring data to this AP,
but when I run the card as AP and connect my iwl3945 laptop to it I
get up to 10x better transfer rates. (but IBSS seems to be slow too).

See http://bugzilla.kernel.org/show_bug.cgi?id=12930 for details.

After seeing "wlan0: beacon loss from AP 00:1c:10:2f:a1:e7 - sending
probe request" I tried to lower the beacon interval on the AP but it
did not change anything.

Also the laptop (using iwl3945) and my Wii are working fine with this AP.

I tried to install windows on this box to test with and the same issue
is there too (limited/slow throughput).

Switching channels do not help either (tried 1,6,8,10 and 12)

I am not sure what is / could be causing this, Luis suggested that I
should post it here.
