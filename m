Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.221.181]:54406 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbZG0RmQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 13:42:16 -0400
Received: by qyk11 with SMTP id 11so861612qyk.33
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2009 10:42:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A6B7752.1080405@gmail.com>
References: <4A6B7752.1080405@gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 27 Jul 2009 10:41:56 -0700
Message-ID: <43e72e890907271041r4738930fr6a3738086fc3a956@mail.gmail.com>
Subject: Re: [PATCH] ath9k: Read outside array bounds
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 25, 2009 at 2:21 PM, Roel Kluin<roel.kluin@gmail.com> wrote:
> Incorrect limits leads to reads outside array bounds.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>

  Luis
