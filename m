Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56970 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754Ab2HFTW5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 15:22:57 -0400
Received: by obbuo13 with SMTP id uo13so6301887obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 12:22:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1344260178-404-1-git-send-email-ozancag@gmail.com>
References: <1344260178-404-1-git-send-email-ozancag@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Mon, 6 Aug 2012 12:22:37 -0700
Message-ID: <CAB=NE6Wj7Pn7+JW8mFYpgk95HuAruczx9P25B6J2kStv5c9ZpA@mail.gmail.com> (sfid-20120806_212301_532156_9A23BE4E)
Subject: Re: [PATCH] compat: Backport kmalloc_array()
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 6, 2012 at 6:36 AM, Ozan Çağlayan <ozancag@gmail.com> wrote:
> The new radeon DRM driver from 3.6 uses kmalloc_array().
>
> This backports:
>
> commit a8203725dfded5c1f79dca3368a4a273e24b59bb
> Author: Xi Wang <xi.wang@gmail.com>
> Date:   Mon Mar 5 15:14:41 2012 -0800
>
>     slab: introduce kmalloc_array()
>
> [root@ozan linux-2.6]# git describe --contains a8203725
> v3.4-rc1~56^2~1
>
> Trying kernel 3.5.0-030500-generic [OK]
> Trying kernel 3.4.4-030404-generic [OK]
> Trying kernel 3.3.7-030307-generic [OK]
> Trying kernel 3.2.2-030202-generic [OK]
> Trying kernel 3.1.10-030110-generic [OK]
> Trying kernel 3.0.18-030018-generic [OK]
> Trying kernel 2.6.39-02063904-generic [OK]
> Trying kernel 2.6.38-02063808-generic [OK]
> Trying kernel 2.6.37-02063706-generic [OK]
> Trying kernel 2.6.36-02063604-generic [OK]
> Trying kernel 2.6.35-02063512-generic [OK]
> Trying kernel 2.6.34-02063410-generic [OK]
> Trying kernel 2.6.33-02063305-generic [OK]
> Trying kernel 2.6.32-02063255-generic [OK]
> Trying kernel 2.6.31-02063113-generic [OK]
> Trying kernel 2.6.30-02063010-generic [OK]
> Trying kernel 2.6.29-02062906-generic [OK]
> Trying kernel 2.6.28-02062810-generic [OK]
> Trying kernel 2.6.27-020627-generic [OK]
> Trying kernel 2.6.26-020626-generic [OK]
> Trying kernel 2.6.25-020625-generic [OK]
> Trying kernel 2.6.24-020624-generic [OK]
>
> Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>

Applied and pushed! Thanks!

  Luis
