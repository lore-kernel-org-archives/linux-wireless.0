Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50351 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444Ab2ARTQ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jan 2012 14:16:29 -0500
Received: by ggnb1 with SMTP id b1so425734ggn.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jan 2012 11:16:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1325604516-14280-1-git-send-email-linville@tuxdriver.com>
References: <1325604516-14280-1-git-send-email-linville@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Wed, 18 Jan 2012 11:16:07 -0800
Message-ID: <CAB=NE6VJK5wohCijn6QMr0FTMV1HXDh1YPOB8d3BvgeuSNS7LQ@mail.gmail.com> (sfid-20120118_201639_629764_EE2ACCBE)
Subject: Re: [PATCH] Enable CONFIG_RT2800{PCI,USB}_RT53XX
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 3, 2012 at 7:28 AM, John W. Linville <linville@tuxdriver.com> wrote:
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> Any reason to treat these differently than the RT35XX devices?

I think no one had just tested it.

Thanks, applied and pushed!

mcgrof@tux ~/linux-stable (git::master)$ git describe --contains
aca355b9784fbc960c9caa6b30f953a965296420
v3.0-rc2~7^2~16^2~158

So I've sucked this into the linux-3.[012].y branches of
compat-wireless for the next stable release.

  Luis
