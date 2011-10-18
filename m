Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36518 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab1JRQl2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 12:41:28 -0400
Received: by bkbzt19 with SMTP id zt19so993769bkb.19
        for <linux-wireless@vger.kernel.org>; Tue, 18 Oct 2011 09:41:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1318929507-11447-2-git-send-email-helmut.schaa@googlemail.com>
References: <1318929507-11447-1-git-send-email-helmut.schaa@googlemail.com> <1318929507-11447-2-git-send-email-helmut.schaa@googlemail.com>
From: Arik Nemtsov <anamtsov@gmail.com>
Date: Tue, 18 Oct 2011 18:41:11 +0200
Message-ID: <CA+XVXfdKPdwXubpnX50zJRCXaxHpubAd3tDgWrCnQQggXKKhPQ@mail.gmail.com> (sfid-20111018_184131_768846_D04C2DE5)
Subject: Re: [PATCH 2/2] iw: show STA flags in station dump
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 18, 2011 at 11:18, Helmut Schaa <helmut.schaa@googlemail.com> wrote:
>
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---
>
> Couldn't come up with a nice/short wording for "Managment frame
> protection" and "Wireless Multimedia Extension" so I just used MFP
> and WME/WMM instead.
>

Printing the NL80211_STA_FLAG_TDLS_PEER flag would be nice as well.

Arik
