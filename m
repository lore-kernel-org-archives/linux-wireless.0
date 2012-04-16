Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52033 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab2DPTY7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 15:24:59 -0400
Received: by bkcik5 with SMTP id ik5so3954416bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 Apr 2012 12:24:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201204161945.08522.s.L-H@gmx.de>
References: <1334572710-10838-1-git-send-email-stas.yakovlev@gmail.com>
	<201204161945.08522.s.L-H@gmx.de>
Date: Mon, 16 Apr 2012 12:24:58 -0700
Message-ID: <CA++WF2Mi7vLf673CNkRtY+8nyFrBgred5faN7rMu+dVv81ygwA@mail.gmail.com> (sfid-20120416_212509_257658_B768490B)
Subject: Re: [PATCH] net/wireless: ipw2200: Fix WARN_ON occurring in
 wiphy_register called by ipw_pci_probe
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@kernel.org, 656813@bugs.debian.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 April 2012 10:45, Stefan Lippers-Hollmann <s.L-H@gmx.de> wrote:
> On Monday 16 April 2012, Stanislav Yakovlev wrote:
>>
>> Stefan, can you test it once again?
>
> I've successfully tested this patch on its own and with Ben Hutching's
> patch ("Bug#656813: [PATCH 1/2] ipw2200: Fix order of
> device registration", Message-ID: <1327201775.8004.83.camel@deadeye>)
> applied on top, it's working fine in both cases. The "cfg80211: failed
> to add phy80211 symlink to netdev!" warning disappears after applying
> both patches to kernel 3.3.2.

Thanks!

Stanislav.
