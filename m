Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62782 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbaD2FYK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Apr 2014 01:24:10 -0400
Received: by mail-lb0-f174.google.com with SMTP id c11so2808522lbj.5
        for <linux-wireless@vger.kernel.org>; Mon, 28 Apr 2014 22:24:08 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 28 Apr 2014 22:24:08 -0700
Message-ID: <CANUX_P1GBeBdPkci6c9cDyz4C4uxA6ktaGvwgPQTDzEPsuEPgg@mail.gmail.com> (sfid-20140429_072426_073507_DAC6F710)
Subject: [ANN] New firmware for Intel 7260 / 3160 - 22.212.9.0
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

we have released a new firmware for 7260, 3160 and 7265 Intel WiFi devices.
This firmware is supported starting 3.14 kernel (when [2] will hit it).
We have a here quite a few bug fixes with a few new features
advertised by flags in the firmware file.
The most visible bug fix is a ping loss issue we had with certain APs
when using uAPSD.

The firmwares are available at [1].
I will send a pull request to linux-firmware.git soon.

The new firmware's version number is 22.212.9.0:

$ dmesg | grep loaded\ firmware
loaded firmware version 22.212.9.0 op_mode iwlmvm

[1] http://wireless.kernel.org/en/users/Drivers/iwlwifi#Firmware
[2] https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/iwlwifi-fixes.git/commit/?id=431031851ea72a25abb9ad4df56a0f3b997e3026
