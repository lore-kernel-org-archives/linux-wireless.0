Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40590 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751519AbdAMKrN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 05:47:13 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Daniel Golle <daniel@makrotopia.org>
Cc: linux-wireless@vger.kernel.org, lede-dev@lists.infradead.org,
        openwrt-devel@lists.openwrt.org, john@phrozen.org, nbd@nbd.name,
        roman@advem.lv, evaxige@qq.com, c.mignanti@gmail.com,
        michel.stempin@wanadoo.fr, vasilugin@yandex.ru,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [RFC] [PULL REQUEST] rt2x00 patches from OpenWrt.org
References: <20170113035020.GA9063@makrotopia.org>
Date: Fri, 13 Jan 2017 12:46:56 +0200
In-Reply-To: <20170113035020.GA9063@makrotopia.org> (Daniel Golle's message of
        "Fri, 13 Jan 2017 04:50:32 +0100")
Message-ID: <87tw93i6e7.fsf@purkki.adurom.net> (sfid-20170113_115419_925985_15F525AC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Golle <daniel@makrotopia.org> writes:

> In preparation to be submitted upstream I started to clean up a huge
> pile of patches for rt2x00 we have been carrying along for quite a
> while (some for more than half a decade!).
> Some of them are fixes, most importantly Serge Vasilugin fixed setting
> the HT20/HT40 filter which got us much closer to the expected
> performance when using HT40 modes.
>
> And also a lot of new added hardware support:
> Gabor Juhos wrote code for Rt3883 WiSoC.
> Daniel Golle implemented support for Rt3352 by designs with external PA
> as well as for boards using a 20MHz crystal instead of the usual 40MHz.
> Serge Vasilugin contributed support for the Rt5350 WiSoC.
> Michel Stempin, Felix Fietkau and John Crispin have been helping with
> cleaning up things and putting away legal doubts.
>
> Please review and comment, so we can get those patches merged!

No pull requests, please. Instead send these as patches, easier to
review and actually also easier for me to merge.

-- 
Kalle Valo
