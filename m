Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fbr02-uk.csee.siteprotect.eu ([81.3.27.132]:55569 "EHLO
	fbr02-uk.csee.siteprotect.eu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751503AbcABQhE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2016 11:37:04 -0500
Received: from smtpauth02-uk.csee.siteprotect.eu (unknown [192.168.22.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client CN "smtp.securepod.com", Issuer "RapidSSL SHA256 CA - G3" (not verified))
	by fbr02-uk.csee.siteprotect.eu (Postfix) with ESMTPS id 112E741639
	for <linux-wireless@vger.kernel.org>; Sat,  2 Jan 2016 17:27:31 +0100 (CET)
Received: from Authenticated sender: roger@beardandsandals.co.uk
	by smtpauth02-uk.csee.siteprotect.eu (Postfix) with ESMTPSA id E73BB40020
	for <linux-wireless@vger.kernel.org>; Sat,  2 Jan 2016 17:27:30 +0100 (CET)
To: linux-wireless@vger.kernel.org
From: Roger James <roger@beardandsandals.co.uk>
Subject: Reading the current monitor flags of an interface
Message-ID: <5687FA72.9000301@beardandsandals.co.uk> (sfid-20160102_173707_470075_5C473AA9)
Date: Sat, 2 Jan 2016 16:27:30 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am trying to get at the current monitor flags setting of a wireless 
monitor mode virtual interface. I have tried to do this by hacking the 
iw source. However I never see a NL80211_ATTR_MNTR_FLAGS attribute 
returned in response to the

TOPLEVEL(info, NULL, NL80211_CMD_GET_INTERFACE, 0, CIB_NETDEV, 
handle_interface_info,
      "Show information for this interface.");

command in iw's interface.c code.

Questions.

1. Am I wasting my time? (e.g. the rt2800usb driver never returns this 
info, or there is another easy way of viewing this info, etc)

2. Am I doing something stupid? (e.g. I need to specify some additional 
flags to the get command.)

3. Has anybody else tried this before?

All help will be gratefully received.

Roger


