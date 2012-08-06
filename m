Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:49755 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762Ab2HFRuu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 13:50:50 -0400
Received: by ggnl2 with SMTP id l2so2768306ggn.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 10:50:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1343862324-26057-3-git-send-email-hauke@hauke-m.de>
References: <1343862324-26057-1-git-send-email-hauke@hauke-m.de> <1343862324-26057-3-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 6 Aug 2012 10:50:29 -0700
Message-ID: <CAB=NE6U0utrarXbqz_zTk_ceoqCmytmpAQSG+uDiAfqmZp0eOA@mail.gmail.com> (sfid-20120806_195053_662941_315BDA43)
Subject: Re: [PATCH 3/3] compat: add sk_wmem_alloc_get and sk_has_allocations
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 1, 2012 at 4:05 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> These functions are copied from the kernel.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Thanks, applied all 3 and pushed!

  Luis
