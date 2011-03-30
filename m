Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34076 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab1C3SMP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2011 14:12:15 -0400
Received: by qwk3 with SMTP id 3so994629qwk.19
        for <linux-wireless@vger.kernel.org>; Wed, 30 Mar 2011 11:12:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1301508166-7692-1-git-send-email-linville@tuxdriver.com>
References: <1301508166-7692-1-git-send-email-linville@tuxdriver.com>
Date: Wed, 30 Mar 2011 20:12:14 +0200
Message-ID: <AANLkTikv+Mpb_P0mDqL1QGWJSynp5U5K+quGxUbuFwRk@mail.gmail.com>
Subject: Re: [PATCH 2.6.39-rc1] b43: allocate receive buffers big enough for
 max frame len + offset
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/3/30 John W. Linville <linville@tuxdriver.com>:
> Otherwise, skb_put inside of dma_rx can fail...

What would happen then? Of course we wouldn't receive packet, but
would we get some warning? Could this be reason of memory leak with
some firmware versions?

-- 
Rafał
