Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35145 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab1D0SJC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 14:09:02 -0400
Received: by mail-iy0-f174.google.com with SMTP id 14so1566629iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Apr 2011 11:09:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1303927456-7067-1-git-send-email-hauke@hauke-m.de>
References: <1303927456-7067-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 27 Apr 2011 11:08:42 -0700
Message-ID: <BANLkTincckkkHyfEG91HxDpbE3sKkjXbeA@mail.gmail.com> (sfid-20110427_200907_011370_2F9B26E5)
Subject: Re: [PATCH] compat: backport vzalloc()
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 27, 2011 at 11:04 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> vzalloc() is used in rtl8192ce now.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Applied, and pushed, thanks.

 Luis
