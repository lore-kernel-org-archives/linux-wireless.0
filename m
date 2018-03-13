Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55948 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932303AbeCMQd1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 12:33:27 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mt7601u: remove a warning in mt7601u_efuse_physical_size_check()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <2850551da4495924bde846dd237b736e41913d0f.1519827461.git.lorenzo.bianconi@redhat.com>
References: <2850551da4495924bde846dd237b736e41913d0f.1519827461.git.lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: kubakici@wp.pl, linux-wireless@vger.kernel.org
Message-Id: <20180313163327.0967460849@smtp.codeaurora.org> (sfid-20180313_173337_953576_EA4694EB)
Date: Tue, 13 Mar 2018 16:33:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Fix the following sparse warning in mt7601u_efuse_physical_size_check:
> - drivers/net/wireless/mediatek/mt7601u/eeprom.c:77:27: warning:
>   Variable length array is used
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Acked-by: Jakub Kicinski <kubakici@wp.pl>

Patch applied to wireless-drivers-next.git, thanks.

3fb2f6a4db98 mt7601u: remove a warning in mt7601u_efuse_physical_size_check()

-- 
https://patchwork.kernel.org/patch/10247613/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
