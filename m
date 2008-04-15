Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58223 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308AbYDOQWe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 12:22:34 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH 09/12] iwl4965: make iwl4956_send_rxon_assocasynchronous
Date: Tue, 15 Apr 2008 09:22:26 -0700
Message-ID: <D936D925018D154694D8A362EEB089200430DFD0@orsmsx416.amr.corp.intel.com> (sfid-20080415_172237_413505_172116ED)
In-Reply-To: <1208276232.14211.28.camel@dv>
References: <1208232974-3828-1-git-send-email-reinette.chatre@intel.com> <1208232974-3828-2-git-send-email-reinette.chatre@intel.com> <1208232974-3828-3-git-send-email-reinette.chatre@intel.com> <1208232974-3828-4-git-send-email-reinette.chatre@intel.com> <1208232974-3828-5-git-send-email-reinette.chatre@intel.com> <1208232974-3828-6-git-send-email-reinette.chatre@intel.com> <1208232974-3828-7-git-send-email-reinette.chatre@intel.com> <1208232974-3828-8-git-send-email-reinette.chatre@intel.com> <1208232974-3828-9-git-send-email-reinette.chatre@intel.com> <1208232974-3828-10-git-send-email-reinette.chatre@intel.com> <1208276232.14211.28.camel@dv>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Pavel Roskin" <proski@gnu.org>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<ipw3945-devel@lists.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, April 15, 2008 9:17 AM, Pavel Roskin  wrote:

> On Mon, 2008-04-14 at 21:16 -0700, Reinette Chatre wrote:
>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
>> Acked-by: Tomas Winkler <tomas.winkler@intel.com>
>> ---
>>  drivers/net/wireless/iwlwifi/iwl4965-base.c |   27
>>  ++++++--------------------- 1 files changed, 6 insertions(+), 21
>> deletions(-) 
>> 
>> diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c
> b/drivers/net/wireless/iwlwifi/iwl4965-base.c
>> index 60c0b83..9fb9857 100644
>> --- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
>> +++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
>> @@ -758,15 +758,8 @@ static int
> iwl4965_full_rxon_required(struct iwl_priv *priv)
>> 
>>  static int iwl4965_send_rxon_assoc(struct iwl_priv *priv)
> 
> Wrong patch description.  Please swap 5 and 6 :-)

Sorry - I do not understand your comment. Could you please elaborate?

Thanks

Reinette

