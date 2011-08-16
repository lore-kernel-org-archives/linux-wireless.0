Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64873 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab1HPTHN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2011 15:07:13 -0400
Received: by ywf7 with SMTP id 7so180240ywf.19
        for <linux-wireless@vger.kernel.org>; Tue, 16 Aug 2011 12:07:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1313513352-32316-1-git-send-email-guy@wizery.com>
References: <1313513352-32316-1-git-send-email-guy@wizery.com>
From: Arik Nemtsov <anamtsov@gmail.com>
Date: Tue, 16 Aug 2011 22:06:53 +0300
Message-ID: <CA+XVXfeiXOdkDueaLJHwLCutBBs5fYOq4+Xdiu9c3aaH-fA9=w@mail.gmail.com> (sfid-20110816_210716_307741_1C68AEEA)
Subject: Re: [PATCH v3] wl12xx: use 2 spare TX blocks for GEM cipher
To: Guy Eilam <guy@wizery.com>
Cc: coelho@ti.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 16, 2011 at 19:49, Guy Eilam <guy@wizery.com> wrote:
> Add tx_spare_blocks member to the wl1271 struct
> for more generic configuration of the amount
> of spare TX blocks that should be used.
> The default value is 1.
> In case GEM cipher is used by the STA, we need
> 2 spare TX blocks instead of just 1.
>
> Signed-off-by: Guy Eilam <guy@wizery.com>
Acked-by: Arik Nemtsov <arik@wizery.com>
