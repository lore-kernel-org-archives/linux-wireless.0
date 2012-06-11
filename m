Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40106 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab2FKXKP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 19:10:15 -0400
Received: by obbtb18 with SMTP id tb18so7388619obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jun 2012 16:10:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1339451135-21087-1-git-send-email-ozancag@gmail.com>
References: <1339451135-21087-1-git-send-email-ozancag@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Mon, 11 Jun 2012 16:09:55 -0700
Message-ID: <CAB=NE6Vr+3vA7TevhLBT0+NZ237p+Gmqui8Za-m7im98mov4Gg@mail.gmail.com> (sfid-20120612_011020_440366_0BBDA93A)
Subject: Re: [PATCH] bin/get-compat-kernels: Do not depend on Ubuntu
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
Cc: mcgrof@kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 11, 2012 at 2:45 PM, Ozan Çağlayan <ozancag@gmail.com> wrote:
> Use Ubuntu PPA vanilla kernels on other distributions too.
> The .deb files are extracted using 'ar' and 'tar'.
>
> Also check if the target directory exists before downloading
> the deb files.

Nice! Some notes below but these things can be addressed as
evolutionary changes. Since we already use sudo the part below is fine
too, but if we can later make ckmake be non-dependent on root that'd
be neat. But merged as-is for now, thanks!

  Luis
