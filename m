Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4.int-evry.fr ([157.159.10.71]:39637 "EHLO
	smtp4.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbYBYRFA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 12:05:00 -0500
Received: from smtp2.int-evry.fr (smtp2.int-evry.fr [157.159.10.45])
	by smtp4.int-evry.fr (Postfix) with ESMTP id 0DA5F350835
	for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 17:31:19 +0100 (CET)
Received: from smtp-ext.int-evry.fr (smtp-ext.int-evry.fr [157.159.11.17])
	by smtp2.int-evry.fr (Postfix) with ESMTP id 999443EDE8D
	for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 17:31:17 +0100 (CET)
Received: from ibook (unknown [77.192.17.45])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp-ext.int-evry.fr (Postfix) with ESMTP id 8EC268D16A2
	for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 17:31:17 +0100 (CET)
From: Florian Fainelli <florian.fainelli@telecomint.eu>
To: linux-wireless@vger.kernel.org
Subject: p54usb with Inventel UR054g dongle
Date: Mon, 25 Feb 2008 17:31:21 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200802251731.22264.florian.fainelli@telecomint.eu> (sfid-20080225_170509_083515_761B3E00)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I am testing an Inventel UR054g dongle with p54usb, and some fields cannot be 
parsed :

p54: LM86 firmware
p54: FW rev 2.5.8.0 - Softmac protocol 3.0
code = 100
data = ecd96a24
code = 6700
data = ecd96a26
code = 1300
data = ecd96c28
p54: not all required entries found in eeprom!
p54: eeprom parse failed!
prism54usb: Invalid hwaddr! Using randomly generated MAC addr

I have added some printks here to show the code it fails to decode and the 
associated eeprom entry.

Do you have any hints about what these particular codes mean ?

Thank you very much in advance.
-- 
