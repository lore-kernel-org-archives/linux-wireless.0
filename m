Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42923 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab1AaXUP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 18:20:15 -0500
Received: by qwa26 with SMTP id 26so6054587qwa.19
        for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 15:20:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1296511604-16921-1-git-send-email-hauke@hauke-m.de>
References: <1296511604-16921-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 31 Jan 2011 15:19:54 -0800
Message-ID: <AANLkTindSu+C+z4xF9G_Er3a8RUsx=POk=v42peWFJ28@mail.gmail.com>
Subject: Re: [PATCH 0/2] compat-wireless: make patches apply again.
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 31, 2011 at 2:06 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> This just makes the patches apply again and builds with some kernels.
> The patch in crap/0002-ath9k-Add-pktlog-support.patch does not apply
> any more and I do not have the time to make it apply again. It should
> be removed or someone else should fix it.
>
> Hauke Mehrtens (2):
>  compat-wireless: adapt chamhes in brcm80211
>  compat-wireless: remove max_brightness

Rock on, thanks a lot Hauke. Applied and pushed.

  Luis
