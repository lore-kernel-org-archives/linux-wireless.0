Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:57419 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756137Ab2JCNyH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Oct 2012 09:54:07 -0400
Received: by obbuo13 with SMTP id uo13so7274301obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2012 06:54:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1347276361.4272.20.camel@jlt4.sipsolutions.net>
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
	<1344426823-1795-8-git-send-email-victorg@ti.com>
	<1347276361.4272.20.camel@jlt4.sipsolutions.net>
Date: Wed, 3 Oct 2012 15:54:06 +0200
Message-ID: <CAK80WHY=YiKBcLgZFJjEEVFk6ncHniPXzWWvKywEGVNLm4C8Kw@mail.gmail.com> (sfid-20121003_155500_339566_C3A1D182)
Subject: Re: [PATCH v3 7/7] mac80211: add DFS support to monitor interface
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 10, 2012 at 2:26 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2012-08-08 at 14:53 +0300, Victor Goldenshtein wrote:
>> AP mode uses monitor interfaces to transmit
>> management frames which were blocked for "radar
>> channels" until now.
>>
>> Stop dropping packets if we are on 'radar channel'
>> and the DFS is enabled.
>
> Umm, no? Check for dfs_en_tx().
>

no need, the AP is started only after the dfs_en_tx().

-- 
Thanks,
Victor.
