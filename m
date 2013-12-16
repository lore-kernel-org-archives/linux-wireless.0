Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:32830 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab3LPJgT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 04:36:19 -0500
Received: by mail-lb0-f169.google.com with SMTP id u14so752675lbd.0
        for <linux-wireless@vger.kernel.org>; Mon, 16 Dec 2013 01:36:17 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 16 Dec 2013 11:36:17 +0200
Message-ID: <CANUX_P3PxN3ENgizJ-V5D0Of45AFoGcJ2wuzW-8ZwzToxTkcdQ@mail.gmail.com> (sfid-20131216_103635_342175_949DA08C)
Subject: [ANN] New firmware for Intel 7260 / 3160
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Seth Forshee <seth.forshee@canonical.com>,
	Matt Chen <machen@suse.com>,
	John Linville <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

We have released a new firmware for 3160 and for 7260 Intel devices.
This firmware is not the firmware that has been long announced. It is
based on the existing code base and has a few bug fixes. This firmware
is supported starting 3.10. A new firmware based on a newer code base
will follow - that new firmware will be supported starting 3.13.

I strongly recommend to move to the new firmware - it solves a few
issues that were raised by users.

The firmware for 7260 is available at [1] and for 3160 at [2].
I will send a pull request to linux-firmware.git soon.
The new firmware's version number is 22.1.7.0:

$ dmesg | grep loaded firmware
loaded firmware version 22.1.7.0 op_mode iwlmvm

[1] - http://wireless.kernel.org/en/users/Drivers/iwlwifi?action=AttachFile&do=get&target=iwlwifi-7260-ucode-22.1.7.0.tgz
[2] - http://wireless.kernel.org/en/users/Drivers/iwlwifi?action=AttachFile&do=get&target=iwlwifi-3160-ucode-22.1.7.0.tgz

Emmanuel Grumbach
egrumbach@gmail.com
