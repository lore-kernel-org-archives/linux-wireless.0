Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34571 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbcCFMkD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2016 07:40:03 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Dima Krasner <dima@dimakrasner.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iw: add libnl-tiny support, reimplemented
References: <20160223204334.4a65ab8113dbe31fbffc56ff@dimakrasner.com>
	<20160305171122.80c2d9a224a4b9632f40585e@dimakrasner.com>
Date: Sun, 06 Mar 2016 14:39:58 +0200
In-Reply-To: <20160305171122.80c2d9a224a4b9632f40585e@dimakrasner.com> (Dima
	Krasner's message of "Sat, 5 Mar 2016 17:11:22 +0200")
Message-ID: <87egbnlqzl.fsf@purkki.adurom.net> (sfid-20160306_134008_515075_8BDE7891)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dima Krasner <dima@dimakrasner.com> writes:

> This allows small static builds, especially when using musl libc.
>
> Signed-off-by: Dima Krasner <dima@dimakrasner.com>

When sending a new version of the patch the standard practise is to add
v2 to the subject, like this:

Subject: [PATCH v2] iw: add libnl-tiny support

-- 
Kalle Valo
