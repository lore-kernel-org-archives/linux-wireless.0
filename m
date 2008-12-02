Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:56334 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbYLBU5J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 15:57:09 -0500
Received: by yx-out-2324.google.com with SMTP id 8so1300755yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2008 12:57:08 -0800 (PST)
Message-ID: <43e72e890812021257p761ab16dqa2058c711349a462@mail.gmail.com> (sfid-20081202_215715_126639_F0322A92)
Date: Tue, 2 Dec 2008 12:57:07 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: stable@kernel.org
Subject: Re: [ath9k-devel] [PATCH 0/3] ath9k: several fixes ported to 2.6.27
Cc: sfr@canb.auug.org.au, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1228251082-11677-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1228251082-11677-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 2, 2008 at 12:51 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> This fixes a few issues seen on MacBook Pros:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=11811
>
> I've ported them to 2.6.27 to help with them being applied sooner.
> I've tried to keep them as small as possible. I don't have the
> ports for 2.6.28 though I think John will be sending them soon
> through his pending-fixes branch.
>
> These are already applied on wireless-testing.

Oh sorry, I noticed patch 2 and 3 didn't go with the subject to
indicate their order. The order they should be applied in is:

0001-ath9k-Fix-SW-IOMMU-bounce-buffer-starvation.patch
0002-ath9k-correct-expected-max-RX-buffer-size.patch
0003-ath9k-Handle-ENOMEM-on-RX-gracefully.patch

You can also find these here:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2008-11-22/27-IOMMU-01/

  Luis
