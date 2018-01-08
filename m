Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37278 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754259AbeAHRc2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 12:32:28 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Colin Ian King <colin.king@canonical.com>
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>, nbd@nbd.name,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76x2: eeprom: fix typo in mt76x2_get_power_info_5g()
References: <cover.1513248071.git.lorenzo.bianconi@redhat.com>
        <2ae397aff0b058615a558a2352067fad2c9201e6.1513248071.git.lorenzo.bianconi@redhat.com>
        <68bc67c3-9c9a-e059-2a2a-1e8ccd5b92f5@canonical.com>
        <87bmj1cmd8.fsf@purkki.adurom.net>
Date: Mon, 08 Jan 2018 19:32:22 +0200
In-Reply-To: <87bmj1cmd8.fsf@purkki.adurom.net> (Kalle Valo's message of "Thu,
        14 Dec 2017 18:20:19 +0200")
Message-ID: <87wp0s5k9l.fsf@purkki.adurom.net> (sfid-20180108_183235_568460_C0C09E8A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Colin Ian King <colin.king@canonical.com> writes:
>
>> On 14/12/17 10:46, Lorenzo Bianconi wrote:
>>> Fix typo in 5GHz power vs channel eeprom parsing
>>> 
>>> Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
>>> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

[...]

>> any possibility of adding:
>>
>> Reported-by: Colin Ian King <colin.king@canonical.com>
>
> Sure, I'll add that during commit.

Actually patchwork added that automatically based on your email, just as
it does with Acked-by. Very nice!

-- 
Kalle Valo
