Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957AbaF2ORk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jun 2014 10:17:40 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Chen-Yu Tsai <wens@csie.org>, linux-wireless@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: [PATCH v4 0/4] brcmfmac: OOB interrupt support
Date: Sun, 29 Jun 2014 16:16:57 +0200
Message-Id: <1404051421-24377-1-git-send-email-hdegoede@redhat.com> (sfid-20140629_161744_933876_C9B22C56)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

Here is v2 of the brcmfmac: OOB interrupt support series.

Changes since v1:
-Post as a stand alone series, rather then together with sunxi pinctrl changes,
 etc.
-Add a patch to fixup the names of the register addresses used in the
 "brcmfmac: Fix OOB interrupt not working for BCM43362" patch
-Use the new register names in:
 "brcmfmac: Fix OOB interrupt not working for BCM43362"

Changes since v2:
-"dt: bindings: add bindings for Broadcom bcm43xx sdio devices"
 * changed the compatible string to brcm,bcm4329-fmac
 * replaced the dt-bindings example with a real world example
-"brcmfmac: Fix OOB interrupt not working for BCM43362"
 * updated commit message with confirmation from broadcom that this is the
   right thing to do

Regards,

Hans
