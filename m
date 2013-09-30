Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:52982 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418Ab3I3U4w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 16:56:52 -0400
Received: by mail-la0-f52.google.com with SMTP id ev20so4863759lab.25
        for <linux-wireless@vger.kernel.org>; Mon, 30 Sep 2013 13:56:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1379399136-3181-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1379399136-3181-1-git-send-email-janusz.dziedzic@tieto.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Mon, 30 Sep 2013 13:56:30 -0700
Message-ID: <CAB=NE6Up37DkyWY__mvAhTb9vd-Rv=oHwsw5851XtAA8ukcYOA@mail.gmail.com> (sfid-20130930_225702_326156_13E71A24)
Subject: Re: [PATCH] cfg80211: parse dfs region for internal regdb option
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 16, 2013 at 11:25 PM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> Add support for parsing and setting the dfs region (ETSI, FCC, JP)
> when the internal regulatory database is used. Before this
> the DFS region was being ignored even if present on the used
> db.txt
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Reviewed-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

It'd be nice to automate the list somehow in the future.

  Luis
