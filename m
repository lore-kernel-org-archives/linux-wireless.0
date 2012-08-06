Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36475 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab2HFRh6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 13:37:58 -0400
Received: by obbuo13 with SMTP id uo13so6177190obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 10:37:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1343862277-26004-1-git-send-email-hauke@hauke-m.de>
References: <1343862277-26004-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 6 Aug 2012 10:37:37 -0700
Message-ID: <CAB=NE6UN8-m2cnDdrJrSsLhD_wYqfi5+Ln8MnQemMiqeg8bfXg@mail.gmail.com> (sfid-20120806_193802_018881_F148BEEA)
Subject: Re: [PATCH] compat-wireless: add patch to make b44 work with < 2.6.36
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 1, 2012 at 4:04 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> The following commit made b44 use 64 bit stats which are not supported
> by kernel version < 2.6.36.
>
> commit eeda8585522bcc173f91d6254dfa63e871087c54
> Author: Kevin Groeneveld <kgroeneveld@gmail.com>
> Date:   Tue Jul 17 17:46:01 2012 +0000
>
>     b44: add 64 bit stats
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Applied and pushed, thanks!

  Luis
