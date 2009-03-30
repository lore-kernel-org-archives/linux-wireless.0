Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:22662 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772AbZC3SrJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 14:47:09 -0400
Received: by wf-out-1314.google.com with SMTP id 29so2721231wff.4
        for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 11:47:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1238257637-15226-1-git-send-email-hauke@hauke-m.de>
References: <1238257637-15226-1-git-send-email-hauke@hauke-m.de>
Date: Mon, 30 Mar 2009 11:46:52 -0700
Message-ID: <43e72e890903301146n3cae5da5v7f5a0b7aa272c95@mail.gmail.com> (sfid-20090330_204713_016216_AA74C30A)
Subject: Re: [PATCH] Backport skb_queue_splice_tail_init to kernel 2.6.27.
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 28, 2009 at 9:27 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Thanks, applied!

v2.6.29-20327-g8f2487d
wireless-testing latest tag:
master-2009-03-27
This is compat-release:
master-2009-03-27

  Luis
