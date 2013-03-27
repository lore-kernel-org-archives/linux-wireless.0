Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4021 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317Ab3C0Lvp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 07:51:45 -0400
Message-ID: <5152DD47.2080501@broadcom.com> (sfid-20130327_125148_862502_882A7E58)
Date: Wed, 27 Mar 2013 12:51:35 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@redhat.com>
cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"David Spinadel" <david.spinadel@intel.com>,
	linux-wireless@vger.kernel.org
Subject: P2P support in brcmfmac
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

In 3.9 we introduced P2P support in brcmfmac which was functional using
current wpa_supplicant P2P support, but we did not yet support the
P2P_DEVICE user-space API.

Last week I enabled that in brcmfmac testing it with wpa_supplicant
patches for P2P_DEVICE support from David Spinadel. So I do have a
couple of brcmfmac patches to make that work and would like to submit
those for 3.9 although it is not strictly a bug fix. Would you consider
taking these?

Regards,
Arend

