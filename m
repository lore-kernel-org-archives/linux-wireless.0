Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59700 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab2LDAWw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 19:22:52 -0500
Received: by mail-wi0-f174.google.com with SMTP id hm9so262501wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Dec 2012 16:22:51 -0800 (PST)
Message-ID: <50BD4257.1080302@gmail.com> (sfid-20121204_012256_234264_E71CB64B)
Date: Tue, 04 Dec 2012 01:22:47 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>,
	greearb@candelatech.com
Subject: change reg domain in EEPROM was Re: Allow over-riding regdomain in
 NIC when CFG80211_CERTIFICATION_ONUS is enabled?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:

> There are out-of-tree patches for ath9k (at least) that allow overriding the
> eeprom reg domain via a module option.
>
> Any chance something like that could make it upstream if it were dependent
> on CFG80211_CERTIFICATION_ONUS?
>
> (We recently got a batch of wpea-127n NICs with country-code of TW, which
> reminded me of this problem).

To modify the EEPROM-reg_domain you can use:

- ath_info for ath5k devices: 
http://madwifi-project.org/wiki/UserDocs/AthInfo
- iwleeprom for ath and iwl devices: http://code.google.com/p/iwleeprom/
