Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:33448 "EHLO
        alexa-out-lv-02.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932578AbdIYHPa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Sep 2017 03:15:30 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [8/10] ath9k: Use ARRAY_SIZE macro
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1504439110050-1887263060-8-diffsplit-thomas@m3y3r.de>
References: <1504439110050-1887263060-8-diffsplit-thomas@m3y3r.de>
To: Thomas Meyer <thomas@m3y3r.de>
CC: <kvalo@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-ID: <27be6ac3227f4738abf6ebea6410c365@euamsexm01a.eu.qualcomm.com> (sfid-20170925_095441_462817_11073D90)
Date: Mon, 25 Sep 2017 09:15:21 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thomas Meyer <thomas@m3y3r.de> wrote:

> Use ARRAY_SIZE macro, rather than explicitly coding some variant of it
> yourself.
> Found with: find -type f -name "*.c" -o -name "*.h" | xargs perl -p -i -e
> 's/\bsizeof\s*\(\s*(\w+)\s*\)\s*\ /\s*sizeof\s*\(\s*\1\s*\[\s*0\s*\]\s*\)
> /ARRAY_SIZE(\1)/g' and manual check/verification.
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

896cbefadf62 ath9k: Use ARRAY_SIZE macro

-- 
https://patchwork.kernel.org/patch/9936271/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
