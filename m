Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sr04-01.mta.terra.com.br ([200.154.152.50]:36707 "EHLO
	sr04-01.mta.terra.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbYL1Get (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Dec 2008 01:34:49 -0500
Received: from ponpeli.hst.terra.com.br (ponpeli.hst.terra.com.br [200.176.10.21])
	by buniche.hst.terra.com.br (Postfix) with ESMTP id 2F47FE000134
	for <linux-wireless@vger.kernel.org>; Sun, 28 Dec 2008 06:34:47 +0000 (UTC)
Received: from [192.168.0.42] (c906e0ca.virtua.com.br [201.6.224.202])
	(authenticated user piterpk)
	by ponpeli.hst.terra.com.br (Postfix) with ESMTP id 520A58000092
	for <linux-wireless@vger.kernel.org>; Sun, 28 Dec 2008 06:34:45 +0000 (UTC)
Message-ID: <49571E29.8060204@unitednerds.org> (sfid-20081228_073510_818671_B265B765)
Date: Sun, 28 Dec 2008 04:35:21 -0200
From: Piter PUNK <piterpunk@unitednerds.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: rt2500usb vs rt73usb
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

I have three rt2573 wireless devices:

. TP-Link WN321G
. D-Link DWA-110
. Built-in inside Intel ClassmatePC

The D-Link device loads only the rt73usb module and
works really fine. The other two loads rt73usb AND
rt2500usb. The correct module for all is rt73usb.

Loading rt2500usb AND rt73usb don't have any functional
problem. All wireless devices works fine. But is very
annoying the additional modules loaded.

Both modules are loaded because both handle 148f:2573
devices. Of course my universe is very small, only two
devices, but... devices 148f:2573 that works with
rt2500usb exists? Those devices can work with rt73usb?

If the those 148f:2573 USB devices doesn't exists or
if they exists and works fine with rt73usb, can we
remove 148f:2573 from rt2500usb?

Thanks!

Piter Punk
