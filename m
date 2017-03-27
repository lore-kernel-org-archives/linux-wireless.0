Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0101.b.hostedemail.com ([64.98.42.101]:34632 "EHLO
        smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752109AbdC0MCh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Mar 2017 08:02:37 -0400
Received: from smtprelay.b.hostedemail.com (10.5.19.248.rfc1918.com [10.5.19.248])
        by smtpgrave02.b.hostedemail.com (Postfix) with ESMTP id 707EC142CA9
        for <linux-wireless@vger.kernel.org>; Mon, 27 Mar 2017 11:53:47 +0000 (UTC)
Received: from filter.hostedemail.com (10.5.19.248.rfc1918.com [10.5.19.248])
        by smtprelay01.b.hostedemail.com (Postfix) with ESMTP id 5DD592D2A13
        for <linux-wireless@vger.kernel.org>; Mon, 27 Mar 2017 11:53:08 +0000 (UTC)
Received: from webmail.lycos.com (imap-ext [64.98.36.5])
        (Authenticated sender: webmail@t.artem@lycos.com)
        by omf07.b.hostedemail.com (Postfix) with ESMTPA
        for <linux-wireless@vger.kernel.org>; Mon, 27 Mar 2017 11:53:08 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 27 Mar 2017 16:53:07 +0500
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: linux-wireless@vger.kernel.org
Subject: Please release/publish iwlwifi-7265D-26.ucode iwlwifi-7265D-25.ucode
 iwlwifi-7265D-24.ucode iwlwifi-7265D-23.ucode
Message-ID: <910ef9cb656db856dd78a919803860b8@lycos.com> (sfid-20170327_140424_579309_F8B15356)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

New versions of iwlwifi require the firmware files which have never been 
released by Intel.

Please fix this bummer.

iwlwifi 0000:02:00.0: Direct firmware load for iwlwifi-7265D-26.ucode 
failed with error -2
iwlwifi 0000:02:00.0: Direct firmware load for iwlwifi-7265D-25.ucode 
failed with error -2
iwlwifi 0000:02:00.0: Direct firmware load for iwlwifi-7265D-24.ucode 
failed with error -2
iwlwifi 0000:02:00.0: Direct firmware load for iwlwifi-7265D-23.ucode 
failed with error -2
iwlwifi 0000:02:00.0: loaded firmware version 22.361476.0 op_mode iwlmvm

Artem
