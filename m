Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.multi.fi ([85.134.37.151]:59124 "EHLO smtp.multi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771Ab2DUV6I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Apr 2012 17:58:08 -0400
Received: from tmb-laptop.supernet (55863541.cust.multi.fi [85.134.53.65] (may be forged))
	by smtp.multi.fi (8.14.4/8.14.4) with ESMTP id q3LLiRqu031596
	for <linux-wireless@vger.kernel.org>; Sun, 22 Apr 2012 00:44:29 +0300
Message-ID: <4F932A3D.2070701@mageia.org> (sfid-20120421_235812_903118_31B5AB43)
Date: Sun, 22 Apr 2012 00:44:29 +0300
From: Thomas Backlund <tmb@mageia.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Missing iwlwifi firmwares ?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

When reviewing our firmware packages I noticed a few missing iwlwifi
firmwares according to kernel-3,3,1


# modinfo iwlwifi
filename:
/lib/modules/3.3.1-desktop-2.mga2/kernel/drivers/net/wireless/iwlwifi/iwlwifi.ko.xz
alias:          iwlagn
license:        GPL
author:         Copyright(c) 2003-2011 Intel Corporation
<ilw@linux.intel.com>
version:        in-tree:d
description:    Intel(R) Wireless WiFi Link AGN driver for Linux

[...]
firmware:       iwlwifi-6000g2a-6.ucode
firmware:       iwlwifi-100-6.ucode
firmware:       iwlwifi-1000-6.ucode
[...]

Theese three are missing from:
http://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git;a=summary

http://intellinuxwireless.org/?n=Downloads


The API 5 ucodes are awailable, but the driver expect API 6...

So..., when will they be available ?
--
Thomas
