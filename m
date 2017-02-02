Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wj0-f195.google.com ([209.85.210.195]:36646 "EHLO
        mail-wj0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751045AbdBBQRD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Feb 2017 11:17:03 -0500
MIME-Version: 1.0
In-Reply-To: <1486030773-30600-1-git-send-email-amadeusz.slawinski@tieto.com>
References: <1486030773-30600-1-git-send-email-amadeusz.slawinski@tieto.com>
From: Adrian Chadd <adrian@freebsd.org>
Date: Thu, 2 Feb 2017 08:17:00 -0800
Message-ID: <CAJ-VmonrHpS3MArM9ohHgLvb6xspP_gnVVeJWA9F-pjUpJ+LZA@mail.gmail.com> (sfid-20170202_171738_657081_76345A36)
Subject: Re: [PATCH 1/3] ath10k: remove ath10k_vif_to_arvif()
To: =?UTF-8?B?QW1hZGV1c3ogU8WCYXdpxYRza2k=?=
        <amadeusz.slawinski@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hiya,

Removing this method makes the diff to FreeBSD larger, as "vif" in
FreeBSD is a different pointer.

(Yes, I have ath10k on freebsd working and I'd like to find a way to
reduce the diff moving forward.)



-adrian
