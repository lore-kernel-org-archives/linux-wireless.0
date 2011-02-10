Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47045 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab1BJRsT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 12:48:19 -0500
Received: by iyj8 with SMTP id 8so1551670iyj.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 Feb 2011 09:48:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297351590-24019-1-git-send-email-hauke@hauke-m.de>
References: <1297351590-24019-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 10 Feb 2011 09:47:43 -0800
Message-ID: <AANLkTinYRLVkXjZ1g8bV6CxEfq-e-JrPBJytETZ2kXeV@mail.gmail.com>
Subject: Re: [PATCH 0/4] compat-wireless: some fixes
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 10, 2011 at 7:26 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> This patch series replaces the old one send on Tuesday.
> Now brcm80211 builds without debugging activated and all patches in the
> patches directory are applying onto todays linux-next.
>
> Hauke Mehrtens (4):
>  compat-wireless: make patches apply again
>  compat-wireless: brcm80211 adapt changes in mac80211
>  compat-wireless: build zd1211rw only for kernel >= 2.6.29
>  compat-wireless: activate BRCMFMAC

Thanks! Applied all and pushed!

  Luis
