Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp203.alice.it ([82.57.200.99]:48404 "EHLO smtp203.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917Ab1KVPGV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 10:06:21 -0500
Received: from trisquel.localnet (80.116.67.249) by smtp203.alice.it (8.6.023.02) (authenticated as editempo@alice.it)
        id 4ECA5E23000B7E12 for linux-wireless@vger.kernel.org; Tue, 22 Nov 2011 16:00:32 +0100
From: "Denis 'GNUtoo' Carikli" <GNUtoo@no-log.org>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: brcmfmac + compat wireless + 2.6.35
Date: Tue, 22 Nov 2011 16:00:31 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201111221600.31514.GNUtoo@no-log.org> (sfid-20111122_160624_974680_4E3979BB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,
With compat wireless on 2.6.35 running on nexus S(also known as crespo or 
herring) I've the dmesg full of
[  109.999238] mmc2:0001:2: pending IRQ with no handler

to make it find the card I've done the a wireless activator that can be found 
here:

http://git.freesmartphone.org/?p=linux-2.6.git;a=commit;h=50ad0092e17490671d44884052545f43c4261234

Is the activator wrong? (there is no runtime PM in 2.6.35 as far as I know).

Denis.
