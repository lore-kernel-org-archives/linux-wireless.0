Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17820 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932302AbcIBP5j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2016 11:57:39 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: replace config_enabled() with IS_REACHABLE()
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1471969646-13119-1-git-send-email-yamada.masahiro@socionext.com>
To: Masahiro Yamada <yamada.masahiro@socionext.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        "Masahiro Yamada" <yamada.masahiro@socionext.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Message-ID: <388c99a317f2431596e43d0feee204c9@euamsexm01a.eu.qualcomm.com> (sfid-20160902_175745_476490_58F0046D)
Date: Fri, 2 Sep 2016 17:57:30 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Masahiro Yamada <yamada.masahiro@socionext.com> wrote:
> Commit 97f2645f358b ("tree-wide: replace config_enabled() with
> IS_ENABLED()") mostly did away with config_enabled().
> 
> This is one of the postponed TODO items as config_enabled() is used
> for a tristate option here.  Theoretically, config_enabled() is
> equivalent to IS_BUILTIN(), but I guess IS_REACHABLE() is the best
> fit for this case because both CONFIG_HWMON and CONFIG_ATH10K are
> tristate.
> 
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>

Thanks, 1 patch applied to ath-next branch of ath.git:

749bc03ae2cd ath10k: replace config_enabled() with IS_REACHABLE()

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9295945/
