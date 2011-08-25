Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49763 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab1HYTMb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 15:12:31 -0400
Received: by qyk38 with SMTP id 38so3638849qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 12:12:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1314184839-13279-3-git-send-email-hauke@hauke-m.de>
References: <1314184839-13279-1-git-send-email-hauke@hauke-m.de> <1314184839-13279-3-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 25 Aug 2011 12:12:10 -0700
Message-ID: <CAB=NE6XM9=pdySaEpzw1R4eGX-zpSyLjeDsvHK3Y88Qt4W-Fyg@mail.gmail.com> (sfid-20110825_211239_770095_A23C1B82)
Subject: Re: [PATCH 3/3] compat: add crc8 lib
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 24, 2011 at 4:20 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> compat/crc8.c was copied from lib/crc8.c and include/linux/crc8.h was
> copied from include/linux/crc8.h
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Awesome stuff, thanks for all the patches, I've applied all 5 pending
compat patches and the 2 pending compat-wireless patches.

  Luis
