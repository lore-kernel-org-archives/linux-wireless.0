Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41520 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753466AbdBNJpS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 04:45:18 -0500
Message-ID: <1487065514.4705.8.camel@sipsolutions.net> (sfid-20170214_104832_348336_7BFA5556)
Subject: Re: [PATCH v2] iw: Fix bitrate output when no rate info found
From: Johannes Berg <johannes@sipsolutions.net>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 14 Feb 2017 10:45:14 +0100
In-Reply-To: <1487065138-4892-1-git-send-email-masashi.honma@gmail.com> (sfid-20170214_103910_037548_15644803)
References: <1487049663-2942-1-git-send-email-masashi.honma@gmail.com>
         <1487065138-4892-1-git-send-email-masashi.honma@gmail.com>
         (sfid-20170214_103910_037548_15644803)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-02-14 at 18:38 +0900, Masashi Honma wrote:
> Previously, bitrate showed uninitialized buffer when no rate info
> found.
> This patch fixes the issue.
> 

Applied, thanks.

johannes
