Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46513 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409Ab1AMA7h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 19:59:37 -0500
Received: by iwn9 with SMTP id 9so1096313iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 Jan 2011 16:59:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1294587141-11353-1-git-send-email-hauke@hauke-m.de>
References: <1294587141-11353-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 12 Jan 2011 16:59:16 -0800
Message-ID: <AANLkTikOx13YasVTm=8XO3ckT1rF-nz77cFOcFUCjgye@mail.gmail.com>
Subject: Re: [PATCH 0/3] compat-wireless: some updates to scripts
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 9, 2011 at 7:32 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> The following commit should also go into stable comat-wireless:
>        184c55e4c41b95c01ea5e4152c613b5c79e44466
>        [PATCH 1/3] compat-wireless: make NEXT_TREE configurable.
>
> Hauke Mehrtens (3):
>  compat-wireless: make NEXT_TREE configurable.
>  compat-wireless: update patches in enable-older-kernels
>  compat-wireless: do not write git-clone

Thanks! Applied all 3 and pushed.

  Luis
