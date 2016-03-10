Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbcCJOzH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 09:55:07 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 107/113] rtl8xxxu: Use define for REG_PWR_DATA bits
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
	<1456783551-28315-108-git-send-email-Jes.Sorensen@redhat.com>
	<87mvq6jsq2.fsf@purkki.adurom.net>
Date: Thu, 10 Mar 2016 09:55:06 -0500
In-Reply-To: <87mvq6jsq2.fsf@purkki.adurom.net> (Kalle Valo's message of "Thu,
	10 Mar 2016 16:46:45 +0200")
Message-ID: <wrfj8u1q2xit.fsf@redhat.com> (sfid-20160310_155511_330410_A350F165)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:
> Jes.Sorensen@redhat.com writes:
>
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>
>> Use the bit define rather than hard code the value for REG_PWR_DATA bits.
>>
>> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> [...]
>
>> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
>> @@ -135,7 +135,7 @@
>>  #define  EFUSE_ACCESS_DISABLE		0x00	/* RTL8723 only */
>>  
>>  #define REG_PWR_DATA			0x0038
>> -#define PWR_DATA_EEPRPAD_RFE_CTRL_EN	BIT(11)
>> +#define  PWR_DATA_EEPRPAD_RFE_CTRL_EN	BIT(11)
>
> Again the two spaces. Is your editor adding them automatically or what?

As in the previous email, this is for bit defines, matching the
register. The above just made it consistent with the rest of the code.

Jes
