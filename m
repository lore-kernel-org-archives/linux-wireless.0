Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34668 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab1GTBJO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 21:09:14 -0400
Received: by qwk3 with SMTP id 3so2279767qwk.19
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2011 18:09:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1310745026-2282-1-git-send-email-sgruszka@redhat.com>
References: <1310745026-2282-1-git-send-email-sgruszka@redhat.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 19 Jul 2011 18:08:53 -0700
Message-ID: <CAB=NE6XK+qdjh-G_HMAE6SKg6UuKfskuVK84iyHDS+4mB-4Dug@mail.gmail.com> (sfid-20110720_030933_819671_3836F268)
Subject: Re: [PATCH 1/2] compat: add pr_<level>_once macros
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 15, 2011 at 8:50 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Add functions from 2.6.38 kernel commit:
>
> commit 16cb839f13324978bd58082e69de81a711802b11
> Author: Joe Perches <joe@perches.com>
> Date:   Wed Jan 12 16:59:46 2011 -0800
>
>    include/linux/printk.h: add pr_<level>_once macros
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Applied both thanks!

  Luis
