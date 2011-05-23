Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41636 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561Ab1EWW6E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 18:58:04 -0400
Received: by iwn34 with SMTP id 34so5241048iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 May 2011 15:58:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1306061227-4159-1-git-send-email-hauke@hauke-m.de>
References: <1306061227-4159-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 23 May 2011 15:57:44 -0700
Message-ID: <BANLkTimKAm9n+2Z0DeDzmJMXi5FPm1S1+A@mail.gmail.com> (sfid-20110524_005809_803547_EB8757EB)
Subject: Re: [PATCH 1/3] Revert "compat-wireless: fix rfkill patches from applying"
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 22, 2011 at 3:47 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> The commit was removed from linux-next, so this backport patch should also be removed.
>
> This reverts commit b8e46e19937710d2ae14731871cf8c45a0fc9d74.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Applied these and also the compat.git ones, and pushed, thanks!

  Luis
