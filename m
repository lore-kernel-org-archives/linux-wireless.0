Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:50824 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535Ab1KUSQT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 13:16:19 -0500
Subject: pci: Rework ASPM disable code patch
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com, mjg@redhat.com, gregkh@suse.de
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Nov 2011 09:20:29 -0800
Message-ID: <1321896029.11647.50.camel@wwguy-huron> (sfid-20111121_191622_484312_29A2F2D8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John/Garrett/Greg,

We test the ASPM patch with the Intel WiFi devices on number of
platforms and the improvement is huge.

In the "idle associated" mode, the power consumption number for our new
devices down to ~40mW range from over 120mW.

We will do more testing but I will suggest to apply this patch to the
stable release.

Thanks
Wey

