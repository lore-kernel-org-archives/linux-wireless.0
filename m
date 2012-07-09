Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:58484 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab2GIWvE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 18:51:04 -0400
Received: by ghrr11 with SMTP id r11so10687680ghr.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2012 15:51:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341844313-12018-1-git-send-email-ozancag@gmail.com>
References: <1341844313-12018-1-git-send-email-ozancag@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Mon, 9 Jul 2012 15:50:42 -0700
Message-ID: <CAB=NE6V6L2SOTV8baRNkcaZ5mBafh-Xr4fuJ06_W0ouZ7_6sGA@mail.gmail.com> (sfid-20120710_005108_376411_B9B9432F)
Subject: Re: [RFC] compat: Don't download ubuntu specific kernel images
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 9, 2012 at 7:31 AM, Ozan Çağlayan <ozancag@gmail.com> wrote:
> The linux-image debs are quite specific to Ubuntu as they will
> at least require generating a compliant initramfs before being able
> to boot into them both in Ubuntu and in other distributions.
>
> The image installation is also the only part that avoids us from
> switching to non-root builds.
>
> Drop this feature completely.
>
> Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>

Looks good -- applied and pushed.

  Luis
