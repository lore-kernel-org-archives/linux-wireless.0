Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36808 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab1A1T5F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 14:57:05 -0500
Message-ID: <4D431F8A.3000403@gmail.com>
Date: Fri, 28 Jan 2011 11:56:58 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: "trivial@kernel.org" <trivial@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]drivers:wireless:acx.h change initate to initiate
References: <1296244204-3890-1-git-send-email-justinmattock@gmail.com> <1296244444.3069.399.camel@pimenta>
In-Reply-To: <1296244444.3069.399.camel@pimenta>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/28/11 11:54, Luciano Coelho wrote:
> On Fri, 2011-01-28 at 20:50 +0100, Justin P. Mattock wrote:
>> Not sure if this is a typo or not. if it is then feel free to take this.
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   drivers/net/wireless/wl12xx/acx.h |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
>> index 7bd8e4d..c56088b 100644
>> --- a/drivers/net/wireless/wl12xx/acx.h
>> +++ b/drivers/net/wireless/wl12xx/acx.h
>> @@ -987,7 +987,7 @@ struct wl1271_acx_ht_capabilities {
>>   	 *         Note, driver will still leave space for HT control in packets
>>   	 *         regardless of the value of this field. FW will be responsible
>>   	 *         to drop the HT field from any frame when this Bit set to 0.
>> -	 * bit 5 - Allow RD initiation in TXOP. FW is allowed to initate RD.
>> +	 * bit 5 - Allow RD initiation in TXOP. FW is allowed to initiate RD.
>>   	 *         Exact policy setting for this feature is TBD.
>>   	 *         Note, this bit can only be set to 1 if bit 3 is set to 1.
>>   	 */
>
> Yep, it's a typo.  Thanks for fixing it.
>
> Acked-by: Luciano Coelho<coelho@ti.com>
>

alright.. cool..

Justin P. Mattock
