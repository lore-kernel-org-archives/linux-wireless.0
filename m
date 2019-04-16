Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45489C282DA
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 08:10:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1E72206BA
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 08:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbfDPIK2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 04:10:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52143 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727326AbfDPIK2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 04:10:28 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hGJAf-0002PE-Ow; Tue, 16 Apr 2019 08:10:25 +0000
Subject: Re: [PATCH] mwifiex: fix spelling mistake "capabilties" ->
 "capabilities"
To:     Mukesh Ojha <mojha@codeaurora.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190415142649.18452-1-colin.king@canonical.com>
 <9347fb11-1c45-3db5-da6b-593dcdc4c2f9@codeaurora.org>
From:   Colin Ian King <colin.king@canonical.com>
Openpgp: preference=signencrypt
Autocrypt: addr=colin.king@canonical.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <0850a0e3-6128-5b6e-8f13-30e333919b79@canonical.com>
Date:   Tue, 16 Apr 2019 09:10:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <9347fb11-1c45-3db5-da6b-593dcdc4c2f9@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 16/04/2019 08:02, Mukesh Ojha wrote:
> 
> On 4/15/2019 7:56 PM, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> There various spelling mistakes in function names and in message
>> text. Fix these.
>>
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> 
> I am hoping you have done the compilation test.

Indeed. It builds fine.

> 
> Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
> 
> Cheers,
> -Mukesh
> 
>> ---
>>   drivers/net/wireless/marvell/mwifiex/sta_event.c | 12 ++++++------
>>   drivers/net/wireless/marvell/mwifiex/uap_event.c |  8 ++++----
>>   2 files changed, 10 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c
>> b/drivers/net/wireless/marvell/mwifiex/sta_event.c
>> index a327fc5b36e3..8b3123cb84c8 100644
>> --- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
>> +++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
>> @@ -27,9 +27,9 @@
>>     #define MWIFIEX_IBSS_CONNECT_EVT_FIX_SIZE    12
>>   -static int mwifiex_check_ibss_peer_capabilties(struct
>> mwifiex_private *priv,
>> -                           struct mwifiex_sta_node *sta_ptr,
>> -                           struct sk_buff *event)
>> +static int mwifiex_check_ibss_peer_capabilities(struct
>> mwifiex_private *priv,
>> +                            struct mwifiex_sta_node *sta_ptr,
>> +                            struct sk_buff *event)
>>   {
>>       int evt_len, ele_len;
>>       u8 *curr;
>> @@ -42,7 +42,7 @@ static int
>> mwifiex_check_ibss_peer_capabilties(struct mwifiex_private *priv,
>>       evt_len = event->len;
>>       curr = event->data;
>>   -    mwifiex_dbg_dump(priv->adapter, EVT_D, "ibss peer capabilties:",
>> +    mwifiex_dbg_dump(priv->adapter, EVT_D, "ibss peer capabilities:",
>>                event->data, event->len);
>>         skb_push(event, MWIFIEX_IBSS_CONNECT_EVT_FIX_SIZE);
>> @@ -937,8 +937,8 @@ int mwifiex_process_sta_event(struct
>> mwifiex_private *priv)
>>                   ibss_sta_addr);
>>           sta_ptr = mwifiex_add_sta_entry(priv, ibss_sta_addr);
>>           if (sta_ptr && adapter->adhoc_11n_enabled) {
>> -            mwifiex_check_ibss_peer_capabilties(priv, sta_ptr,
>> -                                adapter->event_skb);
>> +            mwifiex_check_ibss_peer_capabilities(priv, sta_ptr,
>> +                                 adapter->event_skb);
>>               if (sta_ptr->is_11n_enabled)
>>                   for (i = 0; i < MAX_NUM_TID; i++)
>>                       sta_ptr->ampdu_sta[i] =
>> diff --git a/drivers/net/wireless/marvell/mwifiex/uap_event.c
>> b/drivers/net/wireless/marvell/mwifiex/uap_event.c
>> index ca759d9c0253..86bfa1b9ef9d 100644
>> --- a/drivers/net/wireless/marvell/mwifiex/uap_event.c
>> +++ b/drivers/net/wireless/marvell/mwifiex/uap_event.c
>> @@ -23,8 +23,8 @@
>>     #define MWIFIEX_BSS_START_EVT_FIX_SIZE    12
>>   -static int mwifiex_check_uap_capabilties(struct mwifiex_private *priv,
>> -                     struct sk_buff *event)
>> +static int mwifiex_check_uap_capabilities(struct mwifiex_private *priv,
>> +                      struct sk_buff *event)
>>   {
>>       int evt_len;
>>       u8 *curr;
>> @@ -38,7 +38,7 @@ static int mwifiex_check_uap_capabilties(struct
>> mwifiex_private *priv,
>>       evt_len = event->len;
>>       curr = event->data;
>>   -    mwifiex_dbg_dump(priv->adapter, EVT_D, "uap capabilties:",
>> +    mwifiex_dbg_dump(priv->adapter, EVT_D, "uap capabilities:",
>>                event->data, event->len);
>>         skb_push(event, MWIFIEX_BSS_START_EVT_FIX_SIZE);
>> @@ -201,7 +201,7 @@ int mwifiex_process_uap_event(struct
>> mwifiex_private *priv)
>>                  ETH_ALEN);
>>           if (priv->hist_data)
>>               mwifiex_hist_data_reset(priv);
>> -        mwifiex_check_uap_capabilties(priv, adapter->event_skb);
>> +        mwifiex_check_uap_capabilities(priv, adapter->event_skb);
>>           break;
>>       case EVENT_UAP_MIC_COUNTERMEASURES:
>>           /* For future development */

