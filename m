Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:55340 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757018Ab1KQMdn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 07:33:43 -0500
Received: from aannecy-256-1-57-199.w90-10.abo.wanadoo.fr ([90.10.136.199] helo=[192.168.1.103])
	by casper.infradead.org with esmtpsa (Exim 4.76 #1 (Red Hat Linux))
	id 1RR19y-0005eB-77
	for linux-wireless@vger.kernel.org; Thu, 17 Nov 2011 12:33:42 +0000
Subject: [ANN] NFC daemon open sourced
From: Samuel Ortiz <samuel@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Nov 2011 13:38:02 +0100
Message-ID: <1321533482.30184.6.camel@sortiz-mobl> (sfid-20111117_133346_527185_2FC0ABAC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

This is a quick announcement to let you know that we released our NFC
daemon code. It's available here:

git://git.kernel.org/pub/scm/network/nfc/neard.git

We named it neard, it works on top of the recently merged NFC kernel
subsystem, and it's GPLv2 licensed.

Beside managing the NFC adapters, targets and devices, the main idea of
neard is to expose the NFC data trough a simple D-Bus interface.
Currently we only support reader mode which means we expose the NDEF
records we get from the detected tags.
In the short term, we're working on adding the following features to
neard:

- Bluetooth OOB pairing support.
- Tag writing mode.
- NFC p2p support (This needs some kernel work as well) through npp and
SNEP.

The card emulation support is a bit of a longer term objective. 

We should have our own neard development mailing list fairly soon, I'll
let you know when that happens.

Cheers,
Samuel.



