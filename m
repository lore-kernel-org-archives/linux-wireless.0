Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:65297 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaBGH06 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 02:26:58 -0500
Received: by mail-bk0-f49.google.com with SMTP id v15so928369bkz.36
        for <linux-wireless@vger.kernel.org>; Thu, 06 Feb 2014 23:26:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEFj984TssetDfG=3FnvZhJVxsoYKba+ppoV4nV=R9psfs5B8g@mail.gmail.com>
References: <1391676841-11107-1-git-send-email-michal.kazior@tieto.com>
	<CAEFj984TssetDfG=3FnvZhJVxsoYKba+ppoV4nV=R9psfs5B8g@mail.gmail.com>
Date: Fri, 7 Feb 2014 08:26:56 +0100
Message-ID: <CA+BoTQkhKYa6O3ydVZfCA1k-qihWjUTUJ7JmyBxfxUweVAMZTA@mail.gmail.com> (sfid-20140207_082708_402397_1C3C4E95)
Subject: Re: [PATCH] ath10k: implement sta_rc_update()
From: Michal Kazior <michal.kazior@tieto.com>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 February 2014 19:09, Yeoh Chun-Yeow <yeohchunyeow@gmail.com> wrote:
>> @@ -3091,6 +3160,10 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
>>                            "mac vdev %d peer create %pM (new sta) num_peers %d\n",
>>                            arvif->vdev_id, sta->addr, ar->num_peers);
>>
>> +               memset(&arsta, 0, sizeof(*arsta));
>
> Should be memset(arsta, 0, sizeof(*arsta)), right?

Hmm, I must've sent the old patch because I remember fixing this
already. Anyway - thanks for catching this! I'll send a v2.


Micha³
