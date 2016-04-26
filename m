Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:34835 "EHLO
	mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbcDZHUJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 03:20:09 -0400
Received: by mail-io0-f195.google.com with SMTP id u185so1157342iod.2
        for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2016 00:20:09 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 26 Apr 2016 08:20:08 +0100
Message-ID: <CAL3+40H6tHomoXqAL=m7F5OT4X8+qAm7RGsUyCMw1=U6ROyqhg@mail.gmail.com> (sfid-20160426_092018_199983_6868858D)
Subject: Intel 7260 AC only using 802.11n not AC
From: Radu P <rrrpan@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

These is the relevant data:

firmware-version: 17.265642.0

[  292.689871] iwlwifi 0000:04:00.0: loaded firmware version
17.265642.0 op_mode iwlmvm
[  292.702902] iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band
Wireless AC 7260, REV=0x144

wlan1     IEEE 802.11abgn <- not AC

Kernel version: 4.4.0-21-generic #37~14.04.1-Ubuntu

AC mode is working with Windows 10.

Any help is appreciated!
