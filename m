Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55304 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752434AbcICMb6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 08:31:58 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Baoyou Xie <baoyou.xie@linaro.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@linaro.org, xie.baoyou@zte.com.cn
Subject: Re: fix:rtl8xxxu_core: mark symbols static where possible
References: <20160903102822.84E496201B@smtp.codeaurora.org>
Date: Sat, 03 Sep 2016 08:31:56 -0400
In-Reply-To: <20160903102822.84E496201B@smtp.codeaurora.org> (Kalle Valo's
        message of "Sat, 3 Sep 2016 10:28:22 +0000 (UTC)")
Message-ID: <wrfjpool2mgz.fsf@redhat.com> (sfid-20160903_143221_556552_224C8646)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:
> Baoyou Xie <baoyou.xie@linaro.org> wrote:
>> We get 1 warning about global functions without a declaration
>> in the rtl8xxxu rtl8xxxu_core.c when building with W=1:
>> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:898:1:
>> warning: no previous prototype for 'rtl8xxxu_gen1_h2c_cmd'
>> [-Wmissing-prototypes]
>> 
>> In fact, this function is only used in the file in which it is declared
>> and don't need a declaration, but can be made static.
>> so this patch marks it 'static'.
>> 
>> Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
>
> The title should be "rtl8xxxu: ". See:
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#subject_name
>
> Also I assume Jes will take this.

Yes to both accounts!

Thanks,
Jes
