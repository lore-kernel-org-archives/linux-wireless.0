Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:58936 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860Ab0HRPMK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 11:12:10 -0400
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/4] wl1251: add missing __packed modifier for some structs
References: <1282074415-6168-1-git-send-email-notasas@gmail.com>
	<1282074415-6168-2-git-send-email-notasas@gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 18 Aug 2010 18:12:08 +0300
In-Reply-To: <1282074415-6168-2-git-send-email-notasas@gmail.com> (Grazvydas Ignotas's message of "Tue\, 17 Aug 2010 22\:46\:52 +0300")
Message-ID: <87aaok9cqf.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grazvydas Ignotas <notasas@gmail.com> writes:

> Several acx and cmd structures are missing __packed modifier, add it.
> This was noticed while comparing them with corresponding wl1271 code.

Looks good.

> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>

Acked-by: Kalle Valo <kvalo@adurom.com>

-- 
Kalle Valo
