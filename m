Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38699 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbYLIHd1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 02:33:27 -0500
Subject: Re: iwlagn MAC in deep sleep
From: reinette chatre <reinette.chatre@intel.com>
To: Mike Kershaw <dragorn@kismetwireless.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20081121193348.GA7373@drd1813.lan>
References: <20081121193348.GA7373@drd1813.lan>
Content-Type: text/plain
Date: Mon, 08 Dec 2008 23:34:28 -0800
Message-Id: <1228808068.30670.19.camel@rc-desk> (sfid-20081209_083426_917517_22AAB74C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-11-21 at 11:33 -0800, Mike Kershaw wrote:
> hda_intel: azx_get_response timeout, switching to polling mode: last
> cmd=0x013f000c
> iwlagn: Microcode HW error detected.  Restarting.
> pciehp: Card not present on Slot(3)
> iwlagn: MAC is in deep sleep!
> pciehp: Card present on Slot(3)
> iwlagn: MAC is in deep sleep!
> iwlagn: MAC is in deep sleep!
> iwlagn: MAC is in deep sleep!
> iwlagn: MAC is in deep sleep!
> iwlagn: MAC is in deep sleep!
> iwlagn: MAC is in deep sleep!
> iwlagn: MAC is in deep sleep!
> iwlagn: Unable to init nic
> mac80211-phy14: failed to remove key (0, 00:1a:1e:80:02:a0) from
> hardware
> (-22)
> lib80211: common routines for IEEE802.11 drivers
> iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27kds
> iwlagn: Copyright(c) 2003-2008 Intel Corporation
> 

Could you please try
http://marc.info/?l=linux-wireless&m=122849275528099&w=2 ?

Thank you

Reinette


