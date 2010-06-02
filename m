Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63243 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933199Ab0FBXlH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jun 2010 19:41:07 -0400
Received: by vws11 with SMTP id 11so3227169vws.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jun 2010 16:41:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1275519046-8709-1-git-send-email-vasanth@atheros.com>
References: <1275519046-8709-1-git-send-email-vasanth@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 2 Jun 2010 16:40:45 -0700
Message-ID: <AANLkTimkp8rsXXUVGd5i0jpp-pFhIK7FlRSGOQ6PLcso@mail.gmail.com>
Subject: Re: [PATCH] ath9k: Fix bug in rate table
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 2, 2010 at 3:50 PM, Vasanthakumar Thiagarajan
<vasanth@atheros.com> wrote:
> The following commit added an entry in 11na and 11ng rate
> table but missed to update its rate count field.
>
>        Author: Vasanthakumar Thiagarajan <vasanth@atheros.com>
>        Date:   Thu May 13 18:42:38 2010 -0700
>
>        ath9k: Enable Short GI in 20 Mhz for ar9287 and later chips
>
>        This patch enables short GI rx at all rates and tx at mcs15
>        for 20 Mhz channel width also.
>

What impact did this bug have though?

  Luis
