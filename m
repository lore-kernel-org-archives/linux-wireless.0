Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3217 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061Ab1EIOd3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 10:33:29 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Henry Ptasinski" <henryp@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 1/9] staging: brcm80211: move header file
Date: Mon, 9 May 2011 16:33:02 +0200
Message-ID: <1304951590-2411-2-git-send-email-arend@broadcom.com> (sfid-20110509_163609_518879_7579E87B)
In-Reply-To: <1304951590-2411-1-git-send-email-arend@broadcom.com>
References: <1304951590-2411-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Henry Ptasinski <henryp@broadcom.com>

Move the pci_core.h header file from util to include subdir, in preparation for
other moves and cleanup.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../staging/brcm80211/{util => include}/pci_core.h |    0
 1 files changed, 0 insertions(+), 0 deletions(-)
 rename drivers/staging/brcm80211/{util => include}/pci_core.h (100%)

diff --git a/drivers/staging/brcm80211/util/pci_core.h b/drivers/staging/brcm80211/include/pci_core.h
similarity index 100%
rename from drivers/staging/brcm80211/util/pci_core.h
rename to drivers/staging/brcm80211/include/pci_core.h
-- 
1.7.4.1


