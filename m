Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62515 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab1D0UAC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 16:00:02 -0400
Received: by iyb14 with SMTP id 14so1644027iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Apr 2011 13:00:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1303930882-8529-1-git-send-email-hauke@hauke-m.de>
References: <1303927685.3542.6.camel@jlt3.sipsolutions.net> <1303930882-8529-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 27 Apr 2011 12:59:42 -0700
Message-ID: <BANLkTi=peRsWSJGFb+xhVdZcFKnWnHDZbw@mail.gmail.com> (sfid-20110427_220006_658923_2BCC46D5)
Subject: Re: [PATCH] compat: handle fail of vmalloc()
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 27, 2011 at 12:01 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Only memset the memory if we get a valid pointer.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---

Applied and pushed, thanks!

 Luis
