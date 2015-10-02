Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:37244 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbbJBF2o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 01:28:44 -0400
Received: from mail-io0-f179.google.com (mail-io0-f179.google.com [209.85.223.179])
	(Authenticated sender: b93043)
	by smtp.csie.ntu.edu.tw (Postfix) with ESMTPSA id 33C10207ED
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2015 13:28:43 +0800 (CST)
Received: by iow1 with SMTP id 1so72494683iow.1
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2015 22:28:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20151001212601.GE101875@ubuntu-hedt>
References: <1443682667-29814-1-git-send-email-wens@csie.org> <20151001212601.GE101875@ubuntu-hedt>
From: Chen-Yu Tsai <wens@csie.org>
Date: Fri, 2 Oct 2015 13:28:22 +0800
Message-ID: <CAGb2v67RBbzo-Q1S4xo63=TFqkLxMtN_FHiSa7Yi=ahKw9xi-g@mail.gmail.com> (sfid-20151002_072854_936120_78E23DBB)
Subject: Re: [PATCH v3 0/5] wireless-regdb: Update TW and US rules to latest regulations
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Chen-Yu Tsai <wens@csie.org>,
	wireless-regdb <wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 2, 2015 at 5:26 AM, Seth Forshee <seth.forshee@canonical.com> wrote:
> On Thu, Oct 01, 2015 at 02:57:42PM +0800, Chen-Yu Tsai wrote:
>> Hi Seth,
>>
>> This is v3 of my TW/US 5GHz updates series. Sorry for the long delay.
>>
>> Changes since v2:
>>
>>   - Moved the US U-NII-1 (5150 ~ 5250 MHz) patch in front of the TW patch
>>
>>   - Drop U-NII-1 power limit from 24 dBm to 23 dBm, to be on the safe
>>     side of 250mW
>>
>>
>> Patch 1 updates the 5470 ~ 5725 MHz rules for Taiwan, specifically
>> the opening up of 5600 ~ 5650 MHz spectrum previously allocated to
>> weather radars. The transmission power limit is also corrected to
>> match the regulations.
>>
>> Patch 2 changes the boundary frequencies for each rule for Taiwan to
>> match the frequency allocation table. The "regulation" database shouldn't
>> care about artificial channel boundaries.
>>
>> Patch 3 updates the transmission power limits for 5150 ~ 5250 MHz for
>> the US.
>>
>> Patch 4 adds the previously unusable 5150 ~ 5250 MHz band for Taiwan.
>>
>> Patch 5 updates the transmission power limits for Taiwan, per the NCC's
>> official reply. This patch may be slightly controversial, as there is
>> no official English document. Either someone will have to independently
>> verify this, or translate the Chinese document.
>
> This description doesn't quite match the patches. Patch 4 both adds the
> 5150-5250 MHz band and increases the power limits for 5250-5350 MHz,
> whereas patch 5 changes the DFS master region to DFS-FCC. Previously the
> increased power limit for 5250-5350 MHz was part of patch 5 - perhaps
> you accidentally moved that part to patch 4 when you were updating the
> patches?

Indeed. I squashed a fixup into the wrong patch, and tried to fix it.
Obviously that didn't work out so well.

> So patches 1-3 look fine to me. I suspect you'll want to move the power
> limit increase from patch 4 to 5. I'm also going to take a look at a
> machine translation of the Chinese document, and if that looks to be in
> agreement with your patches then I should be able to apply them next
> week sometime.

Do you want me to send a new version now, or wait for you to go through
the translation first?

Thanks.

ChenYu
