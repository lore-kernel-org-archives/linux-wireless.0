Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37063 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab2FKTtk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 15:49:40 -0400
Received: by obbtb18 with SMTP id tb18so7161118obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jun 2012 12:49:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338418510-4970-1-git-send-email-hauke@hauke-m.de>
References: <1338418510-4970-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 11 Jun 2012 12:49:19 -0700
Message-ID: <CAB=NE6WRP74gu8itYmWoKLrptRpJ879-psKrsrXwpdDpZwiOQg@mail.gmail.com> (sfid-20120611_214943_705306_0FC07D0E)
Subject: Re: [PATCH] compat-wireless: fix syntax error introduced recently
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 30, 2012 at 3:55 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> A closing parenthesis was accentually removed in this commit:
> ommit 86596a46269e9b317ef3ee92f21453320d855018
> Author: Luis R. Rodriguez <mcgrof@frijolero.org>
> Date:   Tue May 29 12:50:42 2012 -0700
>
>    compat-wireless: fix patches/24-pcmcia.patch for next-20120524
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Applied and pushed, thanks!

  Luis
