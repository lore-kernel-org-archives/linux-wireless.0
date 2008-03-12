Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:45008 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbYCLBYt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 21:24:49 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH 0/6] iwlwifi driver updates
Date: Tue, 11 Mar 2008 18:24:35 -0700
Message-ID: <D936D925018D154694D8A362EEB0892003E0210A@orsmsx416.amr.corp.intel.com> (sfid-20080312_012452_471386_C31B3FD0)
In-Reply-To: <20080312004752.GB11612@tuxdriver.com>
References: <1205277440-14323-1-git-send-email-reinette.chatre@intel.com> <20080312004752.GB11612@tuxdriver.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>,
	<ipw3945-devel@lists.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, March 11, 2008 5:48 PM, John W. Linville  wrote:

> On Tue, Mar 11, 2008 at 04:17:14PM -0700, Reinette Chatre wrote:
>> Series contains some fixes as well as changes to move to a shared
>> library design. 
>> 
>> [PATCH 1/6] iwlwifi: fix bug to show hidden APs during scan
>> [PATCH 2/6] iwlwifi: Use sta_bcast_id variable instead of
>> BROADCAST_ID constant [PATCH 3/6] iwlwifi: update copyright year
>> [PATCH 4/6] iwlwifi: Use eeprom form iwlcore
>> [PATCH 5/6] iwlwifi: Fix endianity in debug print
>> [PATCH 6/6] iwlwifi: change rate number to a constant
> 
> The LED support disappeared again?!?!?
> 
> Surely it is time to get _something_ in place to support LEDs on
> these devices? 
> 

Sorry John. The LED support will be pushed soon. We are currently
modifying it to work with the new "iwl-core".

Reinette
