Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:28907 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986AbaAALbL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jan 2014 06:31:11 -0500
From: "Stepanov, Max" <Max.Stepanov@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "Berg, Johannes" <johannes.berg@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: iwlwifi: mvm: add a generic cipher scheme support
Date: Wed, 1 Jan 2014 11:31:06 +0000
Message-ID: <3A934E7FDB083A4683727C7D3770659511739BF3@HASMSX105.ger.corp.intel.com> (sfid-20140101_123115_418822_87D71456)
References: <20131219170541.GA21029@elgon.mountain>
In-Reply-To: <20131219170541.GA21029@elgon.mountain>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>drivers/net/wireless/iwlwifi/mvm/mac80211.c
>   264          /* currently FW API supports only one optional cipher scheme */
>   265          if (mvm->fw->cs && mvm->fw->cs->cipher) {
>                    ^^^^^^^^^^^
>This is an array, not a pointer.

1. Apologies for delay of my reply, I'm back to the office from vacation today.
2. I see that Emmanuel already sent the fix yesterday. See [PATCH 18/28] iwlwifi: mvm: fix harmless smatch / coccinelle warnings

Regards,
Max
