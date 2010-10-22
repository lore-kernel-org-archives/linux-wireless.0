Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:3755 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753104Ab0JVAaB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Oct 2010 20:30:01 -0400
Received: from vs3000.wh2.ocn.ne.jp (125.206.180.163)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0371427397
	for <linux-wireless@vger.kernel.org>; Fri, 22 Oct 2010 09:29:58 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Ben Greear <greearb@candelatech.com>
Subject: Re: [PATCH 0/6] ath9k: fix RX poison issue
Date: Fri, 22 Oct 2010 09:30:01 +0900
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <1287616028-12547-1-git-send-email-lrodriguez@atheros.com> <4CC07CA9.4040808@candelatech.com>
In-Reply-To: <4CC07CA9.4040808@candelatech.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010220930.01071.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri October 22 2010 02:47:21 Ben Greear wrote:
> I tested this code when it was combined into a single patch.
> There were still some issues, but I have no reason to believe
> this patch set caused them.  This patch set significantly
> improved stability in my testing with 130+ STA interfaces.

one question: do you see similar issues with ath5k? i remember one bug is 
filed with a rx poision issue.

thanks,
bruno
