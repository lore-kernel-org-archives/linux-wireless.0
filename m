Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:63833 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab0IIPwH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 11:52:07 -0400
From: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 9 Sep 2010 08:52:03 -0700
Subject: RE: [PATCH 14/16] iwlwifi: replace and add IWL_DEBUG_SCAN
Message-ID: <E9954878DD1FB34FAE5187FB88C58A3501280FDCA3@orsmsx506.amr.corp.intel.com>
References: <1284040354-31703-1-git-send-email-sgruszka@redhat.com>
 <1284040354-31703-15-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1284040354-31703-15-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gruszka,

-----Original Message-----
From: Stanislaw Gruszka [mailto:sgruszka@redhat.com]
Sent: Thursday, September 09, 2010 6:53 AM
To: Johannes Berg; Guy, Wey-Yi W; Chatre, Reinette; John W. Linville
Cc: linux-wireless@vger.kernel.org; Stanislaw Gruszka
Subject: [PATCH 14/16] iwlwifi: replace and add IWL_DEBUG_SCAN

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |   29 ++++++++++++++++++-----------
 1 files changed, 18 insertions(+), 11 deletions(-)

Should this patch merge with patch#5?

Thanks
Wey
