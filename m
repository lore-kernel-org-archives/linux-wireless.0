Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:42356 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab2GJR1x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 13:27:53 -0400
Received: by gglu4 with SMTP id u4so257974ggl.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jul 2012 10:27:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341922388-7799-1-git-send-email-ozancag@gmail.com>
References: <1341922388-7799-1-git-send-email-ozancag@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 10 Jul 2012 10:27:31 -0700
Message-ID: <CAB=NE6UmWwH+y-HP5t500yxPTbU8osZCEvrYNkjGNnppUthdUQ@mail.gmail.com> (sfid-20120710_192756_813058_0C7C2A5C)
Subject: Re: [PATCH] compat: Don't keep 2 URL's per kernel
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 10, 2012 at 5:13 AM, Ozan Çağlayan <ozancag@gmail.com> wrote:
> Generate the filename of ARCH dependent .deb using sed.
> This is much more cleaner and less error-prone.
>
> Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>

Fancy, applied!

  Luis
