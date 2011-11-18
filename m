Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dy0-f46.google.com ([209.85.220.46]:62949 "EHLO
	mail-dy0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984Ab1KRUCN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 15:02:13 -0500
Received: by dyi18 with SMTP id 18so272835dyi.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 12:02:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321645446-22527-2-git-send-email-hauke@hauke-m.de>
References: <1321645446-22527-1-git-send-email-hauke@hauke-m.de> <1321645446-22527-2-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 18 Nov 2011 12:01:50 -0800
Message-ID: <CAB=NE6Vezb619RGWf1vj4Xx=B_pJy_6=5m6xO-GooMPKPQYqhg@mail.gmail.com> (sfid-20111118_210227_085305_BB41A6D6)
Subject: Re: [PATCH 2/3] compat-wireless: escape &
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 18, 2011 at 11:44 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> & needs to be escaped.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

applied and pushed, thanks!


  Luis
