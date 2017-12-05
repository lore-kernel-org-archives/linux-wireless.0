Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43280 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753111AbdLEKER (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Dec 2017 05:04:17 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v8 0/3] mt76: add new wireless driver for MediaTek MT76x2 PCIe chips
References: <20171121095053.82673-1-nbd@nbd.name>
        <87wp22jzzb.fsf@purkki.adurom.net>
        <753050de-c306-838e-98fc-b970cc77ebcf@nbd.name>
Date: Tue, 05 Dec 2017 12:04:07 +0200
In-Reply-To: <753050de-c306-838e-98fc-b970cc77ebcf@nbd.name> (Felix Fietkau's
        message of "Mon, 4 Dec 2017 19:50:13 +0100")
Message-ID: <87k1y1mqy0.fsf@codeaurora.org> (sfid-20171205_110617_222032_F25BFA89)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> writes:

> On 2017-12-04 16:04, Kalle Valo wrote:
>> Felix Fietkau <nbd@nbd.name> writes:
>> 
>>> Changes since v7:
>>> - Fix build errors
>>>
>>> Changes since v6:
>>> - DT documentation fixes
>>> - Add LED configuration
>>> - PHY gain calibration fixes
>>> - Endian fixes
>>> - Tx status processing fixes
>>> - EEPROM validation fixes
>>> - IBSS RSN fix
>>> - AP mode powersave delivery fix
>>>
>>> Changes since v5:
>>> - Adjust for mac80211 API changes
>>> - EEPROM parsing fixes
>>> - Ad-hoc mode WPA2 fixes
>>>
>>> Changes since v4:
>>> - Cleanups suggested by Stanislaw Gruszka
>>> - Device tree fixes suggested by Rob Herring
>>> - EEPROM MAC address parsing fix
>>>
>>> Changes since v3:
>>> - DFS fixes
>>> - stability fixes
>>> - use wiphy_read_of_freq_limits
>>>
>>> Changes since v2:
>>> - lots of checkpatch cleanups
>>> - various tx path (and other) fixes
>>> - use the new bitfield API
>>> - documented device tree bindings
>>>
>>> Felix Fietkau (3):
>>>   Documentation: dt: net: add mt76 wireless device binding
>>>   mt76: add common code shared between multiple chipsets
>>>   mt76: add driver code for MT76x2e
>> 
>> Looking very good to me. Unless I hear any objections I'm planning to
>> apply this within the next few days.
>
> Great news, thanks. Please also apply the two patches from "kbuild test
> robot" that were sent in response to v7 - they still apply to v8.

Sure, I'll apply them as well.

-- 
Kalle Valo
