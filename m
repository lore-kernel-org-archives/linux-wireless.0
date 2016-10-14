Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59785 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbcJNK0j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Oct 2016 06:26:39 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] ath10k: add VHT160 support
Date: Fri, 14 Oct 2016 10:26:34 +0000
Message-ID: <87r37j9qg6.fsf@kamboji.qca.qualcomm.com> (sfid-20161014_122642_769263_FAE2909C)
References: <20161014101710.5300.21550.stgit@potku.adurom.net>
        <20161014101912.5300.66145.stgit@potku.adurom.net>
In-Reply-To: <20161014101912.5300.66145.stgit@potku.adurom.net> (Kalle Valo's
        message of "Fri, 14 Oct 2016 13:19:12 +0300")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
>
> This patch adds full VHT160 support for QCA9984 chipsets Tested on Netgea=
r
> R7800. 80+80 is possible, but disabled so far since it seems to contain
> glitches like missing vht station flags (this may be firmware or mac80211
> related).
>
> Signed-off-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
> Patchwork-Id: 9335111

Oops, the patchwork id is a leftover from my patchwork script. I'll
remove it before I apply the patch.

--=20
Kalle Valo=
