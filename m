Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:3023 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbYGWH5Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 03:57:25 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2660471wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 00:57:24 -0700 (PDT)
Message-ID: <d4b984a30807230057t319eca71g32262305bdb07582@mail.gmail.com> (sfid-20080723_095742_684635_BC6D3593)
Date: Wed, 23 Jul 2008 09:57:24 +0200
From: "Alessandro Guido" <ag@alessandroguido.name>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [BUG] kernel BUG at net/core/dev.c:1328!
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
In-Reply-To: <20080722.155611.176476925.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <d4b984a30807210914nd4d0db5yb7b93ca5143ff0d5@mail.gmail.com>
	 <20080721.092027.14394005.davem@davemloft.net>
	 <d4b984a30807220254t1aaf6ac4q874329966511b0c5@mail.gmail.com>
	 <20080722.155611.176476925.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm testing the latest Linus' git which includes your patch
(2.6.26-06077-gc010b2f) and the problem is fixed.

Thank you!
