Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50959 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756571Ab1AMAz0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 19:55:26 -0500
Received: by iyj18 with SMTP id 18so1049679iyj.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 Jan 2011 16:55:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1294585581-9991-1-git-send-email-hauke@hauke-m.de>
References: <1294585581-9991-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 12 Jan 2011 16:55:05 -0800
Message-ID: <AANLkTikPBfnE80REkfMToR2Dhin8gAbsPkpEhfHqRuf8@mail.gmail.com>
Subject: Re: [PATCH 0/2] compat-wireless-stable-2.6.37
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 9, 2011 at 7:06 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> These two patches should be backported form compat-wireless based on
> linux-next to the stable version 2.6.37 as they are fixing some build
> issues with some kernel version.
>
> Hauke Mehrtens (1):
>  compat-wireless: backport power api in atl1c
>
> Luis R. Rodriguez (1):
>  compat-wireless: remove 28-pm-qos-params.patch

Thanks, I'll apply and kick out a new *clean* release shortly.

  Luis
