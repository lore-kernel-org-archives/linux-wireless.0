Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62958 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab2CaTSE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Mar 2012 15:18:04 -0400
Received: by iagz16 with SMTP id z16so2403945iag.19
        for <linux-wireless@vger.kernel.org>; Sat, 31 Mar 2012 12:18:03 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 31 Mar 2012 15:18:03 -0400
Message-ID: <CAAaUcVyTk7zRs4XACXa_Sw_n6qgcF_7b2Mf_dNhEMsiwgGa_QA@mail.gmail.com> (sfid-20120331_211808_549917_48C38F76)
Subject: BCM4329 chipset -- open80211s
From: Kiran Karra <kiran.karra@gmail.com>
To: linux wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,
I would like to know if I can use open80211s with the BCM4329 chipset?
 From the research I've done, the BCM4329 is a FullMAC device, not a
SoftMAC device.  The open-source linux driver that can work with the
BCM4329 chipset is the brcmfmac.  Therefore, it does not use the
mac80211 framework.  The brcmfmac driver is integrated with cfg80211.
Since open80211s is based off the mac80211 stack, does this mean
open80211s can never be used with brcmfmac?  Is it possible to
interface the open80211s code directly with cfg80211?  Would the
cfg80211 api provide all the necessary callbacks in order to acheive
mesh functionality?  If this is possible, does anyone have an idea of
how much time this effort would require?

Additionally, looking at the documentation on the b43 driver, the
website (http://linuxwireless.org/en/users/Drivers/b43) says that all
BCM43xx are supported by the b43 driver.  The b43 driver does support
open80211s, so I am confused as to whether I can use this driver for
the BCM4329 device, although the device list doesnt have BCM4329?

Are there any other options for getting 802.11s support with the
BCM4329 chipset?

Thanks in advance,
Kiran
