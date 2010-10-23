Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62792 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758462Ab0JWUB0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Oct 2010 16:01:26 -0400
Received: by iwn34 with SMTP id 34so2508466iwn.19
        for <linux-wireless@vger.kernel.org>; Sat, 23 Oct 2010 13:01:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1287857641-7882-2-git-send-email-hauke@hauke-m.de>
References: <1287857641-7882-1-git-send-email-hauke@hauke-m.de> <1287857641-7882-2-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sat, 23 Oct 2010 13:01:03 -0700
Message-ID: <AANLkTimSL7ZEA+Zk9H0drBSciRnF6ZCdZUbYcopV1TGT@mail.gmail.com>
Subject: Re: [PATCH 2/3] compat: lock correct mutex in device_lock
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Blaise Gassend <blaise@willowgarage.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 23, 2010 at 11:14 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> This seams to be an error as all the other functions are working on the
> other struct.
>
> CC: Blaise Gassend <blaise@willowgarage.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Thanks applied and pushed out all 3 patches.

  Luis
