Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:30243 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932428AbYDBUgF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 16:36:05 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [ipw3945-devel] [PATCH] iwlwifi: fix incorrect config variable
Date: Wed, 2 Apr 2008 13:34:40 -0700
Message-ID: <D936D925018D154694D8A362EEB0892004194A10@orsmsx416.amr.corp.intel.com> (sfid-20080402_213637_062038_62FB0415)
In-Reply-To: <1ba2fa240804021317v1ffc4d0br856ae6657683b656@mail.gmail.com>
References: <1207154358-29025-1-git-send-email-reinette.chatre@intel.com> <1ba2fa240804021317v1ffc4d0br856ae6657683b656@mail.gmail.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<ipw3945-devel@lists.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, April 02, 2008 1:17 PM, Tomas Winkler  wrote:

> On Wed, Apr 2, 2008 at 7:39 PM, Reinette Chatre
> <reinette.chatre@intel.com> wrote:
>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>  ---
>>   drivers/net/wireless/iwlwifi/iwl-3945.h |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>>  diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h
> b/drivers/net/wireless/iwlwifi/iwl-3945.h
>>  index ac12269..8114d05 100644
>>  --- a/drivers/net/wireless/iwlwifi/iwl-3945.h
>>  +++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
>>  @@ -779,7 +779,7 @@ struct iwl3945_priv {
>>         struct iwl3945_init_alive_resp card_alive_init;
>>         struct iwl3945_alive_resp card_alive;
>> 
>>  -#ifdef CONFIG_IWL4965_LEDS
>>  +#ifdef CONFIG_IWL3945_LEDS
>>         struct iwl3945_led led[IWL_LED_TRG_MAX];
>>         unsigned long last_blink_time;
>>         u8 last_blink_rate;
> 
> 
> How this one slipped out from the original patch?!
> Tomas
> ACK

My fault - sorry.

Reinette
