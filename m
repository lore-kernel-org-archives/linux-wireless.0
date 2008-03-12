Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4420 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbYCLBXH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 21:23:07 -0400
Date: Tue, 11 Mar 2008 20:47:52 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/6] iwlwifi driver updates
Message-ID: <20080312004752.GB11612@tuxdriver.com> (sfid-20080312_012312_951560_75B4AE15)
References: <1205277440-14323-1-git-send-email-reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1205277440-14323-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 11, 2008 at 04:17:14PM -0700, Reinette Chatre wrote:
> Series contains some fixes as well as changes to move to a shared library
> design.
> 
> [PATCH 1/6] iwlwifi: fix bug to show hidden APs during scan
> [PATCH 2/6] iwlwifi: Use sta_bcast_id variable instead of BROADCAST_ID constant
> [PATCH 3/6] iwlwifi: update copyright year
> [PATCH 4/6] iwlwifi: Use eeprom form iwlcore
> [PATCH 5/6] iwlwifi: Fix endianity in debug print
> [PATCH 6/6] iwlwifi: change rate number to a constant

The LED support disappeared again?!?!?

Surely it is time to get _something_ in place to support LEDs on
these devices?

John
-- 
John W. Linville
linville@tuxdriver.com
