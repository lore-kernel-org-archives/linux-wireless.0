Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45112 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753234AbdIYIYU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Sep 2017 04:24:20 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] rtl8xxxu: Don't printk raw binary if serial number is not
 burned in.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170908103000.6795-1-kilobyte@angband.pl>
References: <20170908103000.6795-1-kilobyte@angband.pl>
To: Adam Borowski <kilobyte@angband.pl>
Cc: Jes Sorensen <Jes.Sorensen@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Stefano Brivio <sbrivio@redhat.com>,
        Adam Borowski <kilobyte@angband.pl>
Message-Id: <20170925082419.E390860618@smtp.codeaurora.org> (sfid-20170925_104609_405360_AC2ADC4D)
Date: Mon, 25 Sep 2017 08:24:19 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adam Borowski <kilobyte@angband.pl> wrote:

> I assume that a blank efuse comes with all ones, thus I did not bother
> recognizing other possible junk values.  This matches 100% of dongles
> I've seen (a single Gembird 8192eu).
> 
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>

Patch applied to wireless-drivers-next.git, thanks.

e0a576d74782 rtl8xxxu: Don't printk raw binary if serial number is not burned in.

-- 
https://patchwork.kernel.org/patch/9943635/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
