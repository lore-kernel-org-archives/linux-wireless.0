Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:34832 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933814Ab1KCQZ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 12:25:27 -0400
Message-ID: <4EB2C073.7080101@neratec.com> (sfid-20111103_172531_578028_79B617D4)
Date: Thu, 03 Nov 2011 17:25:23 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, nbd@openwrt.org
Subject: Re: [RFC v2 1/2] ath9k: add DFS radar pulse processing
References: <1320328553-28066-1-git-send-email-zefir.kurtisi@neratec.com>	<1320328553-28066-2-git-send-email-zefir.kurtisi@neratec.com> <CAD2nsn32rYs4ikwkJOwqfw5gtBU_o8wVGF2WG5-kjFGcTW-rjQ@mail.gmail.com>
In-Reply-To: <CAD2nsn32rYs4ikwkJOwqfw5gtBU_o8wVGF2WG5-kjFGcTW-rjQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/03/2011 04:54 PM, Mohammed Shafi wrote:
> On Thu, Nov 3, 2011 at 7:25 PM, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
>> [...]
>> +static bool postprocess_radar_event(struct ath_softc *sc,
>> +               struct ath_radar_data *are, struct dfs_radar_pulse *drp)
> 
> ath9k_postprocess_radar_event would be better?
> 

Ok (I don't mind, as it's static anyhow.).
