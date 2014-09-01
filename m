Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:41220 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaIAGfW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 02:35:22 -0400
Received: by mail-la0-f48.google.com with SMTP id gl10so5457693lab.7
        for <linux-wireless@vger.kernel.org>; Sun, 31 Aug 2014 23:35:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1409538147-1564-1-git-send-email-rees@umich.edu>
References: <1409538147-1564-1-git-send-email-rees@umich.edu>
Date: Mon, 1 Sep 2014 09:35:21 +0300
Message-ID: <CANUX_P0Cc=ggfecTMF26ZED_PGgXFPR+qur9RAMY=f-2cazEQw@mail.gmail.com> (sfid-20140901_083527_035015_1ADD6E85)
Subject: Re: [PATCH] Revert "iwlwifi: dvm: don't enable CTS to self"
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Jim Rees <rees@umich.edu>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 1, 2014 at 5:22 AM, Jim Rees <rees@umich.edu> wrote:
> Without this revert, my Thinkpad x220 with iwlwifi Ultimate-N 6300 AGN gets
> 35% packet drop rate.
>
> This reverts commit 43d826ca5979927131685cc2092c7ce862cb91cd.
>
> Signed-off-by: Jim Rees <rees@umich.edu>
> ---
>  drivers/net/wireless/iwlwifi/dvm/rxon.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>

Thanks - I already have this in my tree.
