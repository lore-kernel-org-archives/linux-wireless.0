Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:58180 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254Ab2GKOox convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 10:44:53 -0400
Received: by ghrr11 with SMTP id r11so1277431ghr.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jul 2012 07:44:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1342002416-25468-1-git-send-email-ozancag@gmail.com>
References: <1342002416-25468-1-git-send-email-ozancag@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Wed, 11 Jul 2012 07:44:31 -0700
Message-ID: <CAB=NE6X0=+edk6u_rtBg+JQdMHGWNSWjW8jPkq5rThW8PrcmsA@mail.gmail.com> (sfid-20120711_164456_788163_45B7D925)
Subject: Re: [PATCH] compat: Add ability to run as non-root
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 11, 2012 at 3:26 AM, Ozan Çağlayan <ozancag@gmail.com> wrote:
> get-compat-kernels now extracts the kernel headers into
> $HOME/compat-ksrc if the user is not root.
>
> Similarly, ckmake tries first to use $HOME/compat-ksrc if it
> exists. If not, it fallbacks to system-wide /usr/src silently.
>
> Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>

Applied and pushed, thanks!

  Luis
