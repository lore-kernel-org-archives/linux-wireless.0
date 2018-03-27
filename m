Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33264 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751114AbeC0ICG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 04:02:06 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [2/4] wireless: Use octal not symbolic permissions
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <a368e1c4878619172f3da4849cb211b4dfad0a58.1521845237.git.joe@perches.com>
References: <a368e1c4878619172f3da4849cb211b4dfad0a58.1521845237.git.joe@perches.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Eugene Krasnikov <k.eugene.e@gmail.com>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Solomon Peachy <pizza@shaftnet.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wcn36xx@lists.infradead.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Message-Id: <20180327080205.CD80760C54@smtp.codeaurora.org> (sfid-20180327_100232_462932_07C34EB2)
Date: Tue, 27 Mar 2018 08:02:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> wrote:

> Prefer the direct use of octal for permissions.
> 
> Done with checkpatch -f --types=SYMBOLIC_PERMS --fix-inplace
> and some typing.
> 
> Miscellanea:
> 
> o Whitespace neatening around these conversions.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Patch applied to wireless-drivers-next.git, thanks.

2ef00c53049b wireless: Use octal not symbolic permissions

-- 
https://patchwork.kernel.org/patch/10305719/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
