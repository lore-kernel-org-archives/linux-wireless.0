Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:41174 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab2A3NnN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 08:43:13 -0500
Received: by wics10 with SMTP id s10so3421963wic.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2012 05:43:12 -0800 (PST)
MIME-Version: 1.0
From: Tom Gundersen <teg@jklm.no>
Date: Mon, 30 Jan 2012 14:42:52 +0100
Message-ID: <CAG-2HqUqwHo_xgqC79riQF2DA4DPz1Qy5ZARQK8GT+tf_-UKRg@mail.gmail.com> (sfid-20120130_144316_998822_69311B85)
Subject: status of ipw2x00
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linux-wireless@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi guys,

I'm the udev maintainer for Arch Linux, and we have been running into
some problems with the ipw2200 driver[0]. This was most probably
exposed by changes in recent versions of udev, as outlined here [1]
(so will eventually hit the other distros when they upgrade).

I see that the ipw2x00 drivers are listed as Orphaned in MANTAINERS,
and I notice that 2000-series Wireless-N support was added to iwlagn.

Does this mean that we (as a dristro) should drop the ipw2x00 driver
in favor of iwlagn, or do they actualy support different hardware? I
was not able to find any reference to 2000-series Wireless-N chips on
intel.com, so I'm not really sure what hardware this "Intel(R)
Centrino(R) Wireless-N 2200D BGN" is referring to (if it is not [2].
Furthermore, I noticed that the modaliases of the two drivers do not
overlap, which should indicate that they do not support the same
hardware, is that correct?

If we are not able to drop the 2x00 drivers, are anyone still
interested in working on them to fix the firmware loading?

Any help appreciated.

Cheers,

Tom

[0] <https://bugs.archlinux.org/task/28097>
[1] <http://thread.gmane.org/gmane.linux.network/217729>
[2] <http://www.intel.com/support/wireless/wlan/pro2200bg/sb/cs-009093.htm>
