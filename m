Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57085 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbbFHL1Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 07:27:25 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky \(Zhenhui\) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH] brcmfmac: set wiphy perm_addr to hardware MAC address
References: <1433033546-19214-1-git-send-email-zajec5@gmail.com>
Date: Mon, 08 Jun 2015 14:27:19 +0300
In-Reply-To: <1433033546-19214-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Sun, 31 May 2015
 02:52:26 +0200")
Message-ID: <874mmil9t4.fsf@kamboji.qca.qualcomm.com> (sfid-20150608_132732_019556_F799E7F2)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> This allows e.g. user space to use /sys/class/ieee80211/*/macaddress
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Thanks, applied manually.

-- 
Kalle Valo
