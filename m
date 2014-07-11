Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-am1lp0017.outbound.protection.outlook.com ([213.199.154.17]:9032
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751143AbaGKLyz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jul 2014 07:54:55 -0400
From: Igor Bezukh <Igor@galilsoft.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: A question about Wireless dongle HW and driver support - best
 practice
Date: Fri, 11 Jul 2014 11:39:20 +0000
Message-ID: <1405078551691.6483@galilsoft.com> (sfid-20140711_135458_486275_A92F2ADE)
References: <2bac19ce5f704178b25628b5e9e08344@DBXPR07MB093.eurprd07.prod.outlook.com>
In-Reply-To: <2bac19ce5f704178b25628b5e9e08344@DBXPR07MB093.eurprd07.prod.outlook.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

We have an embedded system that consists of Atmel AT91SAM9G20 SoC ( singgle core ARMv5).
This SoC also has USB 1.1 ( 11Mbps).

Kernel version is 2.6.32.

The solution should have two wireless dongles - one acting as Acess Point and the other acting as WiFi client.

In other words, we need the system to be a wireless repeater bridge.

We had a lot of issues with the Atheros CARL9170 drivers and with Ralink 2870.

Ralink 2870 doesn't have support for AP mode, at least in it's 5572 driver pack for linux from Meidatek website.

We need the driver to support both Master and Managed modes, and working on a single CPU core, no SMP.

Can you please suggest a good chipset for such a solution from driver perspective and from HW performance perspective?

TIA,

Igor Bezukh
