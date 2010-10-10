Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hiems2.ing.unibs.it ([192.167.23.204]:42385 "EHLO
	hiems2.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745Ab0JJKTi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Oct 2010 06:19:38 -0400
Subject: Release of Maranello firmware source code for Broadcom cards
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: francesco.gringoli@ing.unibs.it
In-Reply-To: <2518B44B-D014-4ABA-AE31-BD75691488AB@ing.unibs.it>
Date: Sun, 10 Oct 2010 12:19:34 +0200
Cc: b43-dev@lists.infradead.org, Bo Han <bohan@cs.umd.edu>
Message-Id: <1DBB75B1-733F-4DFC-A541-2C2C986586A6@ing.unibs.it>
References: <2518B44B-D014-4ABA-AE31-BD75691488AB@ing.unibs.it>
To: linux-wireless <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello there,

we released the source code of the Maranello firmware and all the
necessary kernel patches. It was tested on Broadcom 4318/4306 pci
cards on PC architecture. Find all the necessary files browsing from

http://www.ing.unibs.it/openfwwf

or go directly here

http://www.cs.umd.edu/projects/maranello


Maranello is an enhancement of the 802.11 DCF standard: it implements
a Partial Packet Recovery technique to retransmit only the corrupt
parts of failed packets. This reduces the airtime and contributes to
enhance the throughput. It was written starting from OpenFWWF5.2 by
adding a number of new features.

Kind regards,
-Francesco Gringoli




Informativa sulla privacy: http://help.ing.unibs.it/privacy.php


