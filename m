Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from embla.aitel.hist.no ([158.38.50.22]:57848 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbYCJKEl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2008 06:04:41 -0400
Message-ID: <47D508A5.6090805@mail.aitel.hist.no> (sfid-20080310_100445_946545_762BF794)
Date: Mon, 10 Mar 2008 11:08:37 +0100
From: Helge Hafting <helgehaf@mail.aitel.hist.no>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: reproducible association with wrong essid, iwl3945
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Get a normal association so the network works. (WEP encryption)
$ iwconfig wlan0 nonexistent_essid key s:correct_key

The network keeps working!  I would expect the driver to look
for an access point with the different essid, and fail
if no such access point exists.
Two different networks with the same encryption string is possible, 
after all.

Helge Hafting
