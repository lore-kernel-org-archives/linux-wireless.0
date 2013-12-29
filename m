Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:46911 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab3L2KCP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Dec 2013 05:02:15 -0500
Received: by mail-la0-f49.google.com with SMTP id er20so4903677lab.8
        for <linux-wireless@vger.kernel.org>; Sun, 29 Dec 2013 02:02:13 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 29 Dec 2013 12:02:13 +0200
Message-ID: <CANUX_P3EwRW=+1SwHQN81hKKGZiVBFDcmLZAqknXZE+UzL_fTA@mail.gmail.com> (sfid-20131229_110224_524766_34B57BAE)
Subject: [ANN] New firmware for Intel 7260 / 3160
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "ilw@linux.intel.com" <ilw@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

We have released a new firmware for 3160 and for 7260 Intel devices.
This firmware includes the neww APIs we have been implementing for a while now.
We have here bug fixes along with better power save and P2P support.
Anyone who wants to use this firmware must have 3.13 at least.
The new file name is iwlwifi-{7260,3160}-8.ucode.
Just copy the file into /lib/firmware - if the driver / kernel
supports the new firmware, it will load the new one. If not,
iwlwifi-{7260,3160}-7.ucode will be loaded and everything should work
just fine.

The firmware for 7260 is available at [1] and for 3160 at [2].
I encourage people running 3.13 and up to take the new firmware and
report issues.
The new firmware's version is 22.15.8.0:

$ dmesg | grep loaded\ firmware
[ 8871.825758] iwlwifi 0000:02:00.0: loaded firmware version 22.15.8.0
op_mode iwlmvm

[1] - http://wireless.kernel.org/en/users/Drivers/iwlwifi?action=AttachFile&do=get&target=iwlwifi-7260-ucode-22.15.8.0.tgz
[2] - http://wireless.kernel.org/en/users/Drivers/iwlwifi?action=AttachFile&do=get&target=iwlwifi-3160-ucode-22.15.8.0.tgz

Emmanuel Grumbach
egrumbach@gmail.com
