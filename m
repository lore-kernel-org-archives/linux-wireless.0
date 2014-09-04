Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:42333 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910AbaIDS7j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 14:59:39 -0400
Message-ID: <5408B698.6050606@candelatech.com> (sfid-20140904_205943_363120_240BAEA2)
Date: Thu, 04 Sep 2014 11:59:36 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: I cannot disable RTS/CTS on ath9k.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My setup is thus:

ath9k station
ath10k AP (RTS not enabled)
ath9k monitor (on separate machine)

I tried enabling (value 1024) and and also disabling RTS on the station.

The station was forced to reconnect after setting the RTS value on
the phy.

But, we sniff RTS being sent by station regardless of the ath9k settings.

I verified RTS configured as requested using 'iw phy phy0 info' and looking
for RTS.

Is there something else that might cause RTS to be sent even when station
is not configured for RTS?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

