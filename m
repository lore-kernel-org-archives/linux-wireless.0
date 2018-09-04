Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48876 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbeIDQIN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 12:08:13 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Wen Gong <wgong@qti.qualcomm.com>
Cc: Wen Gong <wgong@codeaurora.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k\@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [EXTERNAL] Re: [PATCH v3] ath10k: support NET_DETECT WoWLAN feature
References: <1534402113-14337-1-git-send-email-wgong@codeaurora.org>
        <877ek18vyn.fsf@kamboji.qca.qualcomm.com>
        <b6d8ada015e04738b6b3cee95e485e14@aptaiexm02f.ap.qualcomm.com>
Date: Tue, 04 Sep 2018 14:43:23 +0300
In-Reply-To: <b6d8ada015e04738b6b3cee95e485e14@aptaiexm02f.ap.qualcomm.com>
        (Wen Gong's message of "Tue, 4 Sep 2018 11:18:25 +0000")
Message-ID: <87zhwx7ajo.fsf@kamboji.qca.qualcomm.com> (sfid-20180904_134333_133715_DC23043F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wen Gong <wgong@qti.qualcomm.com> writes:

>> > +enum wmi_nlo_cipher_algorithm {
>> > +	WMI_NLO_CIPHER_ALGO_NONE           = 0x00,
>> > +	WMI_NLO_CIPHER_ALGO_WEP40          = 0x01,
>> > +	WMI_NLO_CIPHER_ALGO_TKIP           = 0x02,
>> > +	WMI_NLO_CIPHER_ALGO_CCMP           = 0x04,
>> > +	WMI_NLO_CIPHER_ALGO_WEP104         = 0x05,
>> > +	WMI_NLO_CIPHER_ALGO_BIP            = 0x06,
>> > +	WMI_NLO_CIPHER_ALGO_WPA_USE_GROUP  = 0x100,
>> > +	WMI_NLO_CIPHER_ALGO_RSN_USE_GROUP  = 0x100,
>> 
>> Two defines with the same value 0x100, is this really correct?
>
> Yes, it is an interface between host driver /firmware.

Yeah, I know it's an interface between the host driver and the firmware
but it does not make any sense and is just confusing. Either of them
should be dropped.

-- 
Kalle Valo
