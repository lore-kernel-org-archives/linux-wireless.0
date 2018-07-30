Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44606 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbeG3QGb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jul 2018 12:06:31 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] mt7601u: use sw encryption for hw unsupported ciphers
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <ad9cbcd50cdde4ff997a5ce69265f741114e9af0.1531130155.git.lorenzo.bianconi@redhat.com>
References: <ad9cbcd50cdde4ff997a5ce69265f741114e9af0.1531130155.git.lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: kubakici@wp.pl, linux-wireless@vger.kernel.org, dcaratti@redhat.com
Message-Id: <20180730143115.5651761E66@smtp.codeaurora.org> (sfid-20180730_163118_586450_FF0140A4)
Date: Mon, 30 Jul 2018 14:31:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Fall back to software encryption for hw unsupported ciphers in order
> to enable 802.11w
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

2 patches applied to wireless-drivers-next.git, thanks.

03d677c50ad7 mt7601u: use sw encryption for hw unsupported ciphers
53c2cb8df327 mt7601u: expose 802.11w support

-- 
https://patchwork.kernel.org/patch/10514171/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
