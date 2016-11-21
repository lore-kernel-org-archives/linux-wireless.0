Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:58970 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753975AbcKUNy5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 08:54:57 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: miaoqing@codeaurora.org
Cc: ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4.9.0-rc5] AR9300 calibration problems with antenna selected
References: <m3wpg52hii.fsf@t19.piap.pl>
        <61055e757c5645dfb69da3fc555cbcf5@aptaiexm02f.ap.qualcomm.com>
        <2ea016e563f5db553f201a7d4205c2c0@codeaurora.org>
Date: Mon, 21 Nov 2016 14:54:52 +0100
In-Reply-To: <2ea016e563f5db553f201a7d4205c2c0@codeaurora.org>
        (miaoqing@codeaurora.org's message of "Mon, 21 Nov 2016 13:48:03
        +0800")
Message-ID: <m3d1hp2b0z.fsf@t19.piap.pl> (sfid-20161121_145519_340001_1F371DC6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

miaoqing@codeaurora.org writes:

>> rmmod ath9k
>> modprobe ath9k
>> iw dev wlan0 set type ibss
>> iw phy phyX set antenna 2
>
> 2 is a bad mask. We use bitmap, the valid masks are 1, 3, 7.

Thanks for your response.

I have two antenna connections (and a single antenna). Is it possible to
select the secondary antenna connector only? How?
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
