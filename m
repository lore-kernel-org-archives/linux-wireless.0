Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56678 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751620AbeCMQey (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 12:34:54 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mt7601u: simplify mt7601u_mcu_msg_alloc signature
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <bfc6bf9aa8dc2fe89ad283c457030797d75ec3b8.1520414446.git.lorenzo.bianconi@redhat.com>
References: <bfc6bf9aa8dc2fe89ad283c457030797d75ec3b8.1520414446.git.lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: kubakici@wp.pl, linux-wireless@vger.kernel.org
Message-Id: <20180313163453.AE77D6084A@smtp.codeaurora.org> (sfid-20180313_173500_196906_7E7504F9)
Date: Tue, 13 Mar 2018 16:34:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Remove mt7601u_dev parameter from mt7601u_mcu_msg_alloc signature since
> dev pointer is never used in routine body
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Acked-by: Jakub Kicinski <kubakici@wp.pl>

Patch applied to wireless-drivers-next.git, thanks.

2f04652f891a mt7601u: simplify mt7601u_mcu_msg_alloc signature

-- 
https://patchwork.kernel.org/patch/10263687/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
