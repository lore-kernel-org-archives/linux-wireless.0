Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65097 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469Ab2GIWgq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 18:36:46 -0400
Received: by pbbrp8 with SMTP id rp8so19908121pbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2012 15:36:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341841623-21800-1-git-send-email-ozancag@gmail.com>
References: <1341841623-21800-1-git-send-email-ozancag@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Mon, 9 Jul 2012 15:36:25 -0700
Message-ID: <CAB=NE6UpauAVC6L0SGpf_PhEy6o00jcMaHWDPTv6y3nE0U1YTg@mail.gmail.com> (sfid-20120710_003649_524258_1D239670)
Subject: Re: [PATCH] compat: Directly call perl instead of skip-colors
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 9, 2012 at 6:47 AM, Ozan Çağlayan <ozancag@gmail.com> wrote:
> Since we can now install ckmake with make, drop dependency
> on scripts/skip-colors as it is a simple oneliner. Directly
> call perl instead of using it.
>
> Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>

Applied and pushed, thanks!

 Luis
