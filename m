Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51622 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752436AbeB1O5X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 09:57:23 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] mt7601u: move mt7601u_set_macaddr in mac related code
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <05bb725e26b34bfc88b515110b0fcfb2c6b2303e.1518126991.git.lorenzo.bianconi@redhat.com>
References: <05bb725e26b34bfc88b515110b0fcfb2c6b2303e.1518126991.git.lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: kubakici@wp.pl, linux-wireless@vger.kernel.org
Message-Id: <20180228145723.02C3D607B9@smtp.codeaurora.org> (sfid-20180228_155727_070993_CD9BBF84)
Date: Wed, 28 Feb 2018 14:57:23 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Remove static qualifier from mt7601u_set_macaddr routine and move it
> in mac related code in order to be used to properly support vif with
> different mac address respect to the default one
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

2 patches applied to wireless-drivers-next.git, thanks.

e96826bde3db mt7601u: move mt7601u_set_macaddr in mac related code
032a552e8dc9 mt7601u: set device mac address in mt7601u_add_interface()

-- 
https://patchwork.kernel.org/patch/10208071/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
