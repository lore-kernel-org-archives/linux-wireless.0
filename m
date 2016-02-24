Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40598 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbcBXNv0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 08:51:26 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Oh, Peter" <poh@qca.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] ath10k: rename mesh and add abstraction layer
Date: Wed, 24 Feb 2016 13:51:22 +0000
Message-ID: <87k2lui5d7.fsf@kamboji.qca.qualcomm.com> (sfid-20160224_145129_526951_AD26BDC1)
References: <cover.1454015989.git.poh@qca.qualcomm.com>
In-Reply-To: <cover.1454015989.git.poh@qca.qualcomm.com> (Peter Oh's message
	of "Thu, 28 Jan 2016 13:54:06 -0800")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <poh@qca.qualcomm.com> writes:

> Split Mesh service to 11s Mesh and non-11s Mesh according to
> firmware service bit to help users distinguish 11s Mesh from
> non 11s Mesh.
> And add abstraction layer for vdev subtype to solve subtype mismatch
> and to give flexible compatibility among different firmware revisions.
>
> v2:
>  * Rebased. No code changes.
>
> Peter Oh (4):
>   ath10k: rename Mesh related service names
>   ath10k: update 10.4 WMI service map
>   ath10k: use vif->type and vif->p2p for P2P_GO check
>   ath10k: add abstraction layer for vdev subtype

All applied, thanks.

-- 
Kalle Valo