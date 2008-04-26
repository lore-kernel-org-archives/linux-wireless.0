Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:20476 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbYDZFIe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Apr 2008 01:08:34 -0400
Received: by an-out-0708.google.com with SMTP id d31so1016526and.103
        for <linux-wireless@vger.kernel.org>; Fri, 25 Apr 2008 22:08:33 -0700 (PDT)
Message-ID: <43e72e890804252208g2d19acedh1ceff3aa209489ad@mail.gmail.com> (sfid-20080426_070904_616530_DD435259)
Date: Fri, 25 Apr 2008 22:08:32 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: w35und: one more unneccessary function
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080419194206.GA17558@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080419194206.GA17558@elf.ucw.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 19, 2008 at 12:42 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Remove one more unnecessary function.
>
>  ---
>  commit 8cf2b466620bd533acf20596be1fabfc0b46d992
>  tree e0bf7b039e545bede22980048669557fc49490e4
>  parent 6627ff26a459db3e792ec4dc194122c133c150a5
>  author Pavel <pavel@amd.ucw.cz> Sat, 19 Apr 2008 21:41:31 +0200
>  committer Pavel <pavel@amd.ucw.cz> Sat, 19 Apr 2008 21:41:31 +0200
>
>   .../net/wireless/winbond/winbondport/mlmetxrx.c    |   57 -----------------------
>   1 files changed, 0 insertions(+), 57 deletions(-)
>
>  diff --git a/drivers/net/wireless/winbond/winbondport/mlmetxrx.c b/drivers/net/wireless/winbond/winbondport/mlmetxrx.c
>  index dcfdfd4..f58e458 100644
>  --- a/drivers/net/wireless/winbond/winbondport/mlmetxrx.c
>  +++ b/drivers/net/wireless/winbond/winbondport/mlmetxrx.c

drivers/net/wireless/winbond/ ? What tree is this in?

  Luis
