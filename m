Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38450 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab1IUXEt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 19:04:49 -0400
Received: by iaqq3 with SMTP id q3so2157339iaq.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2011 16:04:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316624777-8001-2-git-send-email-hauke@hauke-m.de>
References: <1316624777-8001-1-git-send-email-hauke@hauke-m.de> <1316624777-8001-2-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 21 Sep 2011 16:04:29 -0700
Message-ID: <CAB=NE6U6QkBujhUPh7gGtVJTC_RwR+Z963wjTXffjADQQ=WVuA@mail.gmail.com> (sfid-20110922_010509_096978_84DC2622)
Subject: Re: [PATCH 2/2] compat-wireless: remove old config options
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 21, 2011 at 10:06 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Both config options have be removed from the Kconfig files in the
> kernel and are not used by the code any more.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Thanks, applied and pushed all 4 patches to both github and
infradead.org in case we get nuked.

  Luis
