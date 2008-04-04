Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:33721 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbYDDVVX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 17:21:23 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH] iwlwifi: honour regulatory restrictions in scan code
Date: Fri, 4 Apr 2008 14:21:21 -0700
Message-ID: <D936D925018D154694D8A362EEB08920041CCB13@orsmsx416.amr.corp.intel.com> (sfid-20080404_222128_852669_825CAFD1)
In-Reply-To: <1207298516.19189.16.camel@johannes.berg>
References: <1207298516.19189.16.camel@johannes.berg>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"John Linville" <linville@tuxdriver.com>
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, April 04, 2008 1:42 AM, Johannes Berg  wrote:

> When doing firmware-assisted scanning, iwlwifi drivers do not
> honour the regulatory control code that might disable channels
> that are enabled in the EEPROM, for example when the user is
> visiting another country and adjusted the regulatory domain
> accordingly. This patch fixes that.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net> ---
> drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 +++
> drivers/net/wireless/iwlwifi/iwl4965-base.c |    3 +++
> 2 files changed, 6 insertions(+)

Thank you

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
