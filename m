Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45669 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab0ITTgV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Sep 2010 15:36:21 -0400
Received: by iwn5 with SMTP id 5so4442470iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Sep 2010 12:36:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1285011044-9662-1-git-send-email-hauke@hauke-m.de>
References: <1285011044-9662-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 20 Sep 2010 12:36:00 -0700
Message-ID: <AANLkTikrEoGMsrF-k5vMCNu20xHFg3aG1ebYMvpeHBDE@mail.gmail.com>
Subject: Re: [PATCH v3] compat-wireless: "backport" pcmcia api changes.
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 20, 2010 at 12:30 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> The PCMCIA API changed again.
> This patch was only compile tested, beacuse I do not have devices to
> test this.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Thanks applied and pushed out.

  Luis
