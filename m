Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45759 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932416AbcDSPoY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 11:44:24 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] ath10k: fix recent checkpatch warnings
Date: Tue, 19 Apr 2016 15:44:21 +0000
Message-ID: <87bn55k3ho.fsf@kamboji.qca.qualcomm.com> (sfid-20160419_174428_526614_791EE1FC)
References: <20160413111247.18823.15952.stgit@potku.adurom.net>
In-Reply-To: <20160413111247.18823.15952.stgit@potku.adurom.net> (Kalle Valo's
	message of "Wed, 13 Apr 2016 14:13:08 +0300")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> I updated checkpatch and noticed that there are few new warnings.
>
> v2:
>
> * fix tests in patch 3
> * add patch 5 to fix a new warning in mac.c
>
> ---
>
> Kalle Valo (5):
>       ath10k: fix checkpatch warnings related to spaces
>       ath10k: prefer kernel type 'u64' over 'u_int64_t'
>       ath10k: prefer ether_addr_equal() or ether_addr_equal_unaligned() over memcmp()
>       ath10k: prefer ether_addr_copy() over memcpy()
>       ath10k: fix parenthesis alignment

Applied.

-- 
Kalle Valo