Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:46943 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab3LaKYS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 05:24:18 -0500
Received: by mail-pb0-f53.google.com with SMTP id ma3so12483870pbc.12
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 02:24:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <f3ed60a9575d7c1f177e09ced775972a0b70ecd0.1388478019.git.gamerh2o@gmail.com>
References: <f3ed60a9575d7c1f177e09ced775972a0b70ecd0.1388478019.git.gamerh2o@gmail.com>
Date: Tue, 31 Dec 2013 15:54:17 +0530
Message-ID: <CAE2MWk=WifPbPf4ER3EsJxh7t9LLxi1qJY=21fCob4Vy2eZu2A@mail.gmail.com> (sfid-20131231_112422_026083_DB8D905A)
Subject: Re: [PATCH] mac80211: fix possible memory leak in ieee80211_register_hw()
From: Ujjal Roy <royujjal@gmail.com>
To: ZHAO Gang <gamerh2o@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 31, 2013 at 2:00 PM, ZHAO Gang <gamerh2o@gmail.com> wrote:
> Before return, free allocated memory in this function.
>
> Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>

very good catch...

-- 
Thanks,
UjjaL Roy
