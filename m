Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:13608 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638AbZAVS0T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 13:26:19 -0500
Received: by fk-out-0910.google.com with SMTP id f33so825207fkf.5
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 10:26:17 -0800 (PST)
To: linux-wireless@vger.kernel.org
Subject: iwl3945 regression: associates but no data is transfered
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 22 Jan 2009 20:26:14 +0200
Message-ID: <87priffb95.fsf@litku.valot.fi> (sfid-20090122_192624_146776_2D7E5703)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I upgraded to the latest wireless-testing and my iwl3945 is now
broken. It can associate but no data is transfered after that. Tried
with open and wep modes. With dhcp I cannot get ip and with static ip
ping to the gateway doesn't work.

Any hints?

-- 
Kalle Valo
