Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:38321 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbYHNRkr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 13:40:47 -0400
Received: by fg-out-1718.google.com with SMTP id 19so461794fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 14 Aug 2008 10:40:46 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net, dcbw@redhat.com
From: Luis Carlos Cobo <luisca@cozybit.com>
Subject: [PATCHv2 0/6] libertas_tf: driver for Marvell 8388 with thin firmware.
Date: Thu, 14 Aug 2008 10:40:45 -0700 (PDT)
Message-ID: <48a46e1d.1438560a.295d.ffff8e18@mx.google.com> (sfid-20080814_194051_569171_79F66C1C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This driver supports the Marvell 8388 USB wireless device, using a thin
firmware. The current "libertas" driver supports the same device but using a
fullmac firmware. Given the big differences in behavior between fullmac and
softmac firmwares, a new separate driver has been developed. Where possible
(specially for usb and fw upload), code has been borrowed from the original
libertas driver.

libertastf is a mac80211 driver that allows the use of 8388 as an AP with
hostap, or as a node in a o11s mesh. 

The appropriate firmware for this driver can be obtained at [1].

[1] http://dev.laptop.org/pub/firmware/libertas/thinfirm/


