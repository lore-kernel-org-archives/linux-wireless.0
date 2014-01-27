Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:5887 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbaA0KY4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jan 2014 05:24:56 -0500
From: "Peer, Ilan" <ilan.peer@intel.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Subject: RE: [PATCH v3 0/6] Enable additional channels for use
Date: Mon, 27 Jan 2014 10:24:52 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A03336C056@HASMSX106.ger.corp.intel.com> (sfid-20140127_112459_957399_7033C4AC)
References: <1390818118-27261-1-git-send-email-ilan.peer@intel.com>
In-Reply-To: <1390818118-27261-1-git-send-email-ilan.peer@intel.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Peer, Ilan
> Sent: Monday, January 27, 2014 12:22
> To: linux-wireless@vger.kernel.org
> Cc: wireless-regdb@lists.infradead.org; Peer, Ilan
> Subject: [PATCH v3 0/6] Enable additional channels for use
> 
> This set addresses comments from Luis:
> 
> 1. Added a regulatory flag that can be used by drivers to disable the P2P
>    GO relaxation.
> 2. Renamed the configuration option to
> CONFIG_CFG80211_REG_P2P_GO_RELAX.

Correction. Renamed it to CONFIG_CFG80211_REG_RELAX_NO_IR ...

Ilan.
