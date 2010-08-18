Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:59034 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278Ab0HRPSj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 11:18:39 -0400
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/4] wl1251: wait for join command complete event
References: <1282074415-6168-1-git-send-email-notasas@gmail.com>
	<1282074415-6168-5-git-send-email-notasas@gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 18 Aug 2010 18:18:38 +0300
In-Reply-To: <1282074415-6168-5-git-send-email-notasas@gmail.com> (Grazvydas Ignotas's message of "Tue\, 17 Aug 2010 22\:46\:55 +0300")
Message-ID: <87wrro7xv5.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grazvydas Ignotas <notasas@gmail.com> writes:

> Poll for join command completion instead of waiting blindly for 10
> msecs. There is a timeout of 100 msecs, if the command doesn't complete
> by then, we return an error code.
>
> Based on wl1271 patch 99d84c1de8fdf5f9b09f07fdbc628857a040bf8b
> by Luciano Coelho.
>
> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>

Acked-by: Kalle Valo <kvalo@adurom.com>

-- 
Kalle Valo
