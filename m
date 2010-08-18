Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:58940 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753806Ab0HRPNF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 11:13:05 -0400
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/4] wl1251: fix event handling mechanism
References: <1282074415-6168-1-git-send-email-notasas@gmail.com>
	<1282074415-6168-3-git-send-email-notasas@gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 18 Aug 2010 18:13:04 +0300
In-Reply-To: <1282074415-6168-3-git-send-email-notasas@gmail.com> (Grazvydas Ignotas's message of "Tue\, 17 Aug 2010 22\:46\:53 +0300")
Message-ID: <8762z89cov.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grazvydas Ignotas <notasas@gmail.com> writes:

> In case both A and B events occured simultaneously, current code
> would only process A and clear both interrupts. Make it process both
> events instead.
>
> Based on wl1271 patches by Juuso Oikarinen:
> 1fd2794f36913992798184c464fe8f85753b13e0
> 13f2dc52c69bcca074cd12d4806953b2af45c386
>
> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>

Acked-by: Kalle Valo <kvalo@adurom.com>

-- 
Kalle Valo
