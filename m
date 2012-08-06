Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46185 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab2HFTbV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 15:31:21 -0400
Received: by obbuo13 with SMTP id uo13so6311824obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 12:31:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1344279307-2929-1-git-send-email-ozancag@gmail.com>
References: <1344279307-2929-1-git-send-email-ozancag@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Mon, 6 Aug 2012 12:31:00 -0700
Message-ID: <CAB=NE6VUDjOYGWBz=TbsgTV+FvGg0Z+T=vhPeLcfsOoiuzErfg@mail.gmail.com> (sfid-20120806_213124_455526_D25D1119)
Subject: Re: [PATCH 1/2] compat-wireless: Minor cosmetic changes in admin-update.sh
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
Cc: mcgrof@kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 6, 2012 at 11:55 AM, Ozan Çağlayan <ozancag@gmail.com> wrote:
> - Move functions above everything,
> - Use $HOME instead of /home/$USER which fails when run as root,
> - Enhance comments
> - Mention about compat/bin/get-compat-trees for fetching the trees.
>
> Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>

I've applied this, thanks! In the future though please break down the
above changes into more atomic patches. This makes review and
bisecting easier if ever needed.

  Luis
