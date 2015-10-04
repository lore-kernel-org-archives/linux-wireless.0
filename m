Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:33473 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbbJDTiq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 15:38:46 -0400
Received: by wiclk2 with SMTP id lk2so93526106wic.0
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2015 12:38:45 -0700 (PDT)
Message-ID: <56118043.3080509@read.org.nz> (sfid-20151004_213850_404200_FF308D08)
Date: Sun, 04 Oct 2015 20:38:43 +0100
From: Morgan Read <mstuff@read.org.nz>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: sgruszka@redhat.com
Subject: iwlegacy and bridging iwl3945...? (sort of)
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

https://wireless.wiki.kernel.org/en/users/drivers/iwlegacy

('$ ethtool -i wlp16s0' says 'driver: iwl3945' but
https://wireless.wiki.kernel.org/en/users/drivers/iwl3945
links here
https://wireless.wiki.kernel.org/en/users/Drivers/iwlwifi
then here
https://wireless.wiki.kernel.org/en/users/drivers/iwlegacy
So, running fedora 21, I assume the above means my driver is iwlegacy)


Hello Folks,

I have a deceptively simply questions;
Will this iwlegacy driver driving iwl3945 hardware work as per this
How To here:
https://wiki.debian.org/BridgeNetworkConnections#Bridging_with_a_wireless_NIC
?

That How To provides (to a novice) a comprehensive explanation to the 
problem of bridging a wireless connection that seems to be universal to 
all wireless connections.  But, there are other explanations of the 
wireless bridging problem which make me suspicious it might not work...

Warning here:
http://www.linux-kvm.org/page/Networking#public_bridge

Explanation here:
http://www.linuxfoundation.org/collaborate/workgroups/networking/bridge#It_doesn.27t_work_with_my_Wireless_card.21

So, can I expect to be able to bridge my 802.11 connection to work with 
my KVM guests?

(I'm setting up an old laptop to run as a home server.)

Many thanks for your help.
Morgan.

-- 
Morgan Read
UNITED KINGDOM
<mailto:mstuffATreadDOTorgDOTnz>

Confused about DRM?
Get all the info you need at:
http://drm.info/

