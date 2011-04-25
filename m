Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45836 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758842Ab1DYSqh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 14:46:37 -0400
Received: by iyb14 with SMTP id 14so2056262iyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 25 Apr 2011 11:46:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1303661475-26632-2-git-send-email-hauke@hauke-m.de>
References: <1303661475-26632-1-git-send-email-hauke@hauke-m.de> <1303661475-26632-2-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 25 Apr 2011 11:46:17 -0700
Message-ID: <BANLkTikA6WjdXTWmMRvi7xALsSZEhqyn0Q@mail.gmail.com> (sfid-20110425_204642_986591_B3CF7C6C)
Subject: Re: [PATCH 2/2] compat: fix TASK_INTERRUPTIBLE missing
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 24, 2011 at 9:11 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> When compiling against the Ubuntu Natty kernel (2.6.38-8-generic)
> TASK_INTERRUPTIBLE is not defined here.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Applied both and pushed, thanks!

  Luis
