Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45149 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab0KCUt5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 16:49:57 -0400
Received: by fxm16 with SMTP id 16so887692fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Nov 2010 13:49:55 -0700 (PDT)
Message-ID: <4CD1CB0C.6050502@lwfinger.net>
Date: Wed, 03 Nov 2010 15:50:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH] b43legacy: rfkill: use status register based on core
 revision (not PHY's)
References: <1288816572-12743-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1288816572-12743-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/03/2010 03:36 PM, Rafał Miłecki wrote:
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> With this patch we follow specs. I hope this will fix bug where radio was
> magically auto-turning on/off. Unfortunately I didn't get answer from reporter
> of that issue.
> 
> John: I suggest taking it for 2.6.38

ACK, both for the patch and the suggestion for the timing.

Larry
