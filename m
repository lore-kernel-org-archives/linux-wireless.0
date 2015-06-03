Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4256 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbbFCJ44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 05:56:56 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Souptick Joarder <jrdr.linux@gmail.com>
CC: Yanbo Li <yanbol@qca.qualcomm.com>, <ath10k@lists.infradead.org>,
	<dreamfly281@gmail.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: Debugfs entry to enable/disable WLAN&Blutooth Coexist feature
References: <1432840745-21725-1-git-send-email-yanbol@qca.qualcomm.com>
	<CAFqt6zbpEfX_DPwZwzVZkcUD3uuYa=-Ujuo9PXcB+-HtM9b8tA@mail.gmail.com>
Date: Wed, 3 Jun 2015 12:56:47 +0300
In-Reply-To: <CAFqt6zbpEfX_DPwZwzVZkcUD3uuYa=-Ujuo9PXcB+-HtM9b8tA@mail.gmail.com>
	(Souptick Joarder's message of "Wed, 3 Jun 2015 09:05:15 +0530")
Message-ID: <87iob5t8rk.fsf@kamboji.qca.qualcomm.com> (sfid-20150603_115701_935740_E83D472C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Souptick Joarder <jrdr.linux@gmail.com> writes:

> From patch it looks like we can optimize the size of char buf [32] to
> 16 /8 as it is only going to store 0 or 1. If there are some other
> purpose to keep it 32 , then I apologize for the noise.

I'm going to send v3 which will use dev_flags bitmap.

-- 
Kalle Valo
