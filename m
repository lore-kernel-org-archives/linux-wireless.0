Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:57950 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab0CJB1W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 20:27:22 -0500
Received: by bwz1 with SMTP id 1so4525719bwz.21
        for <linux-wireless@vger.kernel.org>; Tue, 09 Mar 2010 17:27:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <6c6bb6f91003091723t31972586uba80a0a849f3634@mail.gmail.com>
References: <6c6bb6f91003091723t31972586uba80a0a849f3634@mail.gmail.com>
From: Alastair McKinley <amckinley03@googlemail.com>
Date: Wed, 10 Mar 2010 01:27:01 +0000
Message-ID: <6c6bb6f91003091727p322c5589n117a7d774094b20c@mail.gmail.com>
Subject: building the rt2x00 drivers on compat-wireless
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everyone,

I'm on ubuntu karmic and I recently installed ath5k from
compat-wireless 2.6.33-rc4.  Upgrading ath5k works great but seems to
have broken my usb adaptor with is some sort of rt2x00 device.
Whenever I insert the adaptor I get a lot of:

>>
>> rt2x00lib: disagrees about version of symbol ieee80211_register_hw
>>
>> [249986.361060] rt2x00lib: Unknown symbol ieee80211_register_hw
>>
>> [249986.361503] rt2x00lib: disagrees about version of symbol ieee80211_get_hdrlen_from_skb
>>
>> [249986.361509] rt2x00lib: Unknown symbol ieee80211_get_hdrlen_from_skb
>>
>> [249986.361727] rt2x00lib: disagrees about version of symbol ieee80211_wake_queue
>>
>> [249986.361733] rt2x00lib: Unknown symbol ieee80211_wake_queue
>>
>> [249986.362182] rt2x00lib: disagrees about version of symbol ieee80211_tx_status_irqsafe
>>
>> [249986.362188] rt2x00lib: Unknown symbol ieee80211_tx_status_irqsafe
>


I guess this is because of the new mac80211 module from
compat-wireless mismatch with my original rt2x00 driver.

So my question is, how do you build rt2x00 and friends from
compat-wireless, there doesn't seem to be an option in
./scripts/driver-select.

Any help would be greatly appreciated!

Alastair
