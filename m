Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:7643 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbYGDRnu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2008 13:43:50 -0400
Received: by yw-out-2324.google.com with SMTP id 9so567449ywe.1
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jul 2008 10:43:40 -0700 (PDT)
Subject: Support for 1.103 firmware on at76 devices
From: Milan Plzik <milan.plzik@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Fri, 04 Jul 2008 19:43:35 +0200
Message-Id: <1215193415.4619.16.camel@localhost> (sfid-20080704_194353_859563_F327808C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

  following series of patches applies to current wireless-testing adds
support for 1.103 firmware (and thus for at least RC4/TKIP, AES/CCMP was
not possible to test, although support is implemented). In this form
patches should autodetect firmware version and properly operate with
both, but only operation with 1.103 firmware was tested, as the primary
intention was to get these devices working with this version of
firmware.

  Patches are more or less split to first fix issues in current driver,
then adds support for WEP and finally for WPA.

  Please test the driver if possible, and send me reports about any
possible bugs, or objections; I will try to implement required changes.
Unfortunately, I'm leaving for a vacation on July 6th up to July 17th,
so I will not be able to respond during this period.

  Best regards,
	Milan Plzik

