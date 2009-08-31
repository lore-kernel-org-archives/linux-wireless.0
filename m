Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:48457 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbZHaQsN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2009 12:48:13 -0400
Subject: Re: Inter 5300 AGN with unsupported EEPROM
From: reinette chatre <reinette.chatre@intel.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4A9B0BF8.3040505@lwfinger.net>
References: <4A9B0BF8.3040505@lwfinger.net>
Content-Type: text/plain
Date: Mon, 31 Aug 2009 09:48:14 -0700
Message-Id: <1251737294.13180.4.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

On Sun, 2009-08-30 at 16:32 -0700, Larry Finger wrote:
> Most of the thread is useless as the OP wouldn't supply critical data
> and persisted in various rants, but on the 3rd page, he finally
> provided the output of 'dmesg | grep iwl', which was
> 
> iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
> iwlagn: Copyright(c) 2003-2008 Intel Corporation
> iwlagn 0000:07:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> iwlagn 0000:07:00.0: setting latency timer to 64
> iwlagn: Detected Intel Wireless WiFi Link 5300AGN REV=0x24
> iwlagn: Unsuported EEPROM VER=0x114 < 0x11a CALIB=0x3 < 0x4
> iwlagn 0000:07:00.0: PCI INT A disabled
> iwlagn: probe of 0000:07:00.0 failed with error -22
> 
> The OP states that this device came from Best Buy. What is the current
> scoop on this EEPROM version?

All production cards are supported by the driver. I thus do not know how
an unsupported card can be obtained from a reputable dealer. Would it be
possible to obtain images of both sides of this card showing all numbers
clearly? You can send this to me off list and I can see if it is
possible to determine what type of card we are dealing with here.

Thank you

Reinette


