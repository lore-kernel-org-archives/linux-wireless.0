Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50616 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab1JJXcj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 19:32:39 -0400
Received: by ggnv2 with SMTP id v2so5041436ggn.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 16:32:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6XU57NLU=Tq_eqWoUtK_ppdd-PBH=tGCbEu7vQ1cPzpyQ@mail.gmail.com>
References: <1317772067-6998-1-git-send-email-mcgrof@qca.qualcomm.com>
 <CAB=NE6V1gUSNc4L8sNv-NnDDVSzDB4A=cc_Z7tmZ79Q4LKtbwQ@mail.gmail.com>
 <CAB=NE6VxNKJPQPBbkn9ha1EC6dWawj96B6f-R1XREN1JAcrOQQ@mail.gmail.com>
 <CAB=NE6U6hFMBhgkjhpjpQk+FpMbDi4X6aW6i70MUWRH73K+AuQ@mail.gmail.com>
 <CAB=NE6Xz26oOudnyw17_1ijqe+L8qwQAGH8qjZEocgHQOY54eg@mail.gmail.com>
 <4E908C6D.7040703@neratec.com> <CAB=NE6UouofityugcjTvcXpBFx6cYEbAQ_FAe3gPO-GaS8Vh3w@mail.gmail.com>
 <4E92B74F.9030901@neratec.com> <CAB=NE6XU57NLU=Tq_eqWoUtK_ppdd-PBH=tGCbEu7vQ1cPzpyQ@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Mon, 10 Oct 2011 16:32:18 -0700
Message-ID: <CAB=NE6V5s64kiiPMmPbs8bnbRwtvPMGAnRFfk5zDmomzyFc_xg@mail.gmail.com> (sfid-20111011_013243_115503_C817CA11)
Subject: Re: [PATCH 0/8] wireless: add DFS master support
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 10, 2011 at 12:05 PM, Luis R. Rodriguez
<mcgrof@qca.qualcomm.com> wrote:
> Sure, I'll respin my patches to use only 2 bits for now on the
> wireless-regdb. As far as nl80211 is concerned though since we can
> only send U8 as a minimum I'll define this as a NL80211_CTRY_REQS and
> we can stuff whatever we want into it later on CRDA.

And more to Johannes' point, my kernel patches can go as-is, the only
one that needs to deal with the nastiness is crda.c, not even the
wireless-regdb patches need to be respin'd. I did make a typo on
nl80211.h though so I will have to respin, also for the sake of
clarity.

  Luis
