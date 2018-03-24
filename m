Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0100.hostedemail.com ([216.40.44.100]:35674 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751891AbeCXMtf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Mar 2018 08:49:35 -0400
Message-ID: <1521895769.24655.10.camel@perches.com> (sfid-20180324_134939_624352_60A7F8B3)
Subject: Re: [PATCH 2/4] wireless: Use octal not symbolic permissions
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Jiri Slaby <jirislaby@gmail.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
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
        linux-kernel@vger.ke
Date: Sat, 24 Mar 2018 05:49:29 -0700
In-Reply-To: <87zi2xss27.fsf@purkki.adurom.net>
References: <cover.1521845235.git.joe@perches.com>
         <a368e1c4878619172f3da4849cb211b4dfad0a58.1521845237.git.joe@perches.com>
         <87zi2xss27.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2018-03-24 at 12:09 +0200, Kalle Valo wrote:
> Joe Perches <joe@perches.com> writes:
> > Prefer the direct use of octal for permissions.
[]
> I don't know what tree are you planning to send these to, but I would
> prefer to take this to wireless-drivers-next to minimise any conflicts.

Fine by me.  Done against -next.
