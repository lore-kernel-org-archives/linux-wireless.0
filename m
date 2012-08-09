Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:43252 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755980Ab2HIMJA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 08:09:00 -0400
Received: by ggnf4 with SMTP id f4so381343ggn.0
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2012 05:08:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120809115109.GB3516@redhat.com>
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
	<1344426823-1795-2-git-send-email-victorg@ti.com>
	<20120809115109.GB3516@redhat.com>
Date: Thu, 9 Aug 2012 15:08:59 +0300
Message-ID: <CAK80WHYjhBbE5Y2Q_-QhbNmxu76BMRCa9=vFyMXwQJQqsGiPUQ@mail.gmail.com> (sfid-20120809_140904_836617_B048FA51)
Subject: Re: [PATCH v3 1/7] nl80211/cfg80211: add radar detection command/event
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, johannes@sipsolutions.net,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 9, 2012 at 2:51 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Wed, Aug 08, 2012 at 02:53:37PM +0300, Victor Goldenshtein wrote:
>> +     cac_type = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
>> +     if (cac_type != NL80211_CHAN_HT20)
>> +             return -EOPNOTSUPP;
> Since only HT20 is supported, what for we have this variable?
>

Security measures and preparation for future HT40.

-- 
Thanks,
Victor.
