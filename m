Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.225]:47328 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbYB1WAG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2008 17:00:06 -0500
Received: by wr-out-0506.google.com with SMTP id c48so5439945wra.23
        for <linux-wireless@vger.kernel.org>; Thu, 28 Feb 2008 14:00:05 -0800 (PST)
Message-ID: <43e72e890802281400s33c8cd6fk8835c46eaf7d00ff@mail.gmail.com> (sfid-20080228_220015_949087_2B615504)
Date: Thu, 28 Feb 2008 17:00:03 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: iwl3945 Microcode SW error, and then can't stop Rx DMA
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After a while of running on my iwl3945 I get the following error:

[ 8414.072734] wlan0: CTS protection disabled (BSSID=00:13:c4:f4:25:30)
[ 8473.409534] wlan0: CTS protection enabled (BSSID=00:13:c4:f4:25:30)
[12059.081930] iwl3945: Microcode SW error detected.  Restarting 0x82000008.
[12059.081950] iwl3945: Error Reply type 0x00000005 cmd REPLY_TX
(0x1C) seq 0x0000 ser 0x0000004B
[12060.076397] iwl3945: Can't stop Rx DMA.

I then have to remove the module and add it back. Haven't been able to
replicate it again, but will let you know once I do see it again. This
is running the latest pull from wireless-testing.git.

  Luis
