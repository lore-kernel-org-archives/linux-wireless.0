Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:5330 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbYBARrx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 12:47:53 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH 2/2] iwlwifi: set rate_idx correctly from plcp
Date: Fri, 1 Feb 2008 09:40:25 -0800
Message-ID: <D936D925018D154694D8A362EEB08920038F3E76@orsmsx416.amr.corp.intel.com> (sfid-20080201_174801_881664_1DD7D76E)
In-Reply-To: <33E1C72C74DBE747B7B59C1740F7443702C96D93@orsmsx417.amr.corp.intel.com>
References: <1201844801-7326-1-git-send-email-reinette.chatre@intel.com> <1201844801-7326-2-git-send-email-reinette.chatre@intel.com> <1ba2fa240802010343q519a1dap9d4af5ef5e0110f2@mail.gmail.com> <33E1C72C74DBE747B7B59C1740F7443702C96D93@orsmsx417.amr.corp.intel.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Abbas, Mohamed" <mohamed.abbas@intel.com>,
	"Tomas Winkler" <tomasw@gmail.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, February 01, 2008 8:29 AM, Abbas, Mohamed  wrote:

> From: Tomas Winkler [mailto:tomasw@gmail.com]
> Sent: Friday, February 01, 2008 3:44 AM
> On Feb 1, 2008 7:46 AM, Reinette Chatre
> <reinette.chatre@intel.com> wrote:
>> From: Mohamed Abbas <mohamed.abbas@intel.com>
>> 
>> rate_idx is derived from plcp information
>> 
>> Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com> ---
>>  drivers/net/wireless/iwlwifi/iwl-4965.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>> 

[..snip..]

> NACK
> This should be
> rate_idx =
> iwl4965_rate_index_from_plcp(wl4965_hw_get_rate(rx_start->rate_
> n_flags)); 
> 
> iwl4965_hw_get_rate - this one extract plcp from rate_n_flags - also
> takes care of endinaity Tomas
> 
> Actually iwl4965_rate_index_from_plcp expect rate and flag
> data to get the rate index.
> Mohamed

John,

Sorry about the confusing emails - please go ahead and apply this patch.

Thank you

Reinette
