Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367AbaFPR5h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 13:57:37 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Chen-Yu Tsai <wens@csie.org>, linux-wireless@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: [PATCH v2 0/4] brcmfmac: OOB interrupt support
Date: Mon, 16 Jun 2014 19:56:43 +0200
Message-Id: <1402941407-8210-1-git-send-email-hdegoede@redhat.com> (sfid-20140616_195742_056792_4769B119)
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

Regards,

Hans

