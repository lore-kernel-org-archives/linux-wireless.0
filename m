Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44095 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757668Ab0JUOE3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Oct 2010 10:04:29 -0400
Received: by ywi6 with SMTP id 6so2744683ywi.19
        for <linux-wireless@vger.kernel.org>; Thu, 21 Oct 2010 07:04:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1287668824-3096-2-git-send-email-senthilkumar@atheros.com>
References: <1287668824-3096-1-git-send-email-senthilkumar@atheros.com> <1287668824-3096-2-git-send-email-senthilkumar@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 21 Oct 2010 07:04:07 -0700
Message-ID: <AANLkTi=cH3GeAa-s8iSMEs=ckRoeeF7=w1Kz4t6ABHNd@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] cfg80211: add debug print when processing a channel
To: Senthil Balasubramanian <senthilkumar@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Easwar Krishnan <easwar.krishnan@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 21, 2010 at 6:47 AM, Senthil Balasubramanian
<senthilkumar@atheros.com> wrote:
> From: Luis R. Rodriguez <lrodriguez@atheros.com>
>
> In the worst case you are seeing really odd things you want
> more information than what is provided right now, for those
> that insist and want debug info through CONFIG_CFG80211_REG_DEBUG
> provide a print of when we are processing a channel and with what
> regulatory rule.
>
> Cc: Easwar Krishnan <easwar.krishnan@atheros.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
> ---
> v2 -- fixed compilation error if REG_DEBUG is not defined.

Thanks !!

  Luis
