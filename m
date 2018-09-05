Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47490 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbeIEHTR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 03:19:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 05 Sep 2018 10:51:19 +0800
From: Wen Gong <wgong@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Wen Gong <wgong@qti.qualcomm.com>, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v3] ath10k: support NET_DETECT WoWLAN feature
In-Reply-To: <87zhwx7ajo.fsf@kamboji.qca.qualcomm.com>
References: <1534402113-14337-1-git-send-email-wgong@codeaurora.org>
 <877ek18vyn.fsf@kamboji.qca.qualcomm.com>
 <b6d8ada015e04738b6b3cee95e485e14@aptaiexm02f.ap.qualcomm.com>
 <87zhwx7ajo.fsf@kamboji.qca.qualcomm.com>
Message-ID: <92bec84a762be7589b13274fb30dd649@codeaurora.org> (sfid-20180905_045128_166561_C73D7B6C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-09-04 19:43, Kalle Valo wrote:
> Wen Gong <wgong@qti.qualcomm.com> writes:
> 
>>> > +enum wmi_nlo_cipher_algorithm {
>>> > +	WMI_NLO_CIPHER_ALGO_NONE           = 0x00,
>>> > +	WMI_NLO_CIPHER_ALGO_WEP40          = 0x01,
>>> > +	WMI_NLO_CIPHER_ALGO_TKIP           = 0x02,
>>> > +	WMI_NLO_CIPHER_ALGO_CCMP           = 0x04,
>>> > +	WMI_NLO_CIPHER_ALGO_WEP104         = 0x05,
>>> > +	WMI_NLO_CIPHER_ALGO_BIP            = 0x06,
>>> > +	WMI_NLO_CIPHER_ALGO_WPA_USE_GROUP  = 0x100,
>>> > +	WMI_NLO_CIPHER_ALGO_RSN_USE_GROUP  = 0x100,
>>> 
>>> Two defines with the same value 0x100, is this really correct?
>> 
>> Yes, it is an interface between host driver /firmware.
> 
> Yeah, I know it's an interface between the host driver and the firmware
> but it does not make any sense and is just confusing. Either of them
> should be dropped.
yes, either of them can be dropped.
