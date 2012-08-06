Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:52388 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586Ab2HFTjL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 15:39:11 -0400
Received: by ggnl2 with SMTP id l2so2906634ggn.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 12:39:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1344279938-4789-1-git-send-email-ozancag@gmail.com>
References: <1344279938-4789-1-git-send-email-ozancag@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Mon, 6 Aug 2012 12:38:50 -0700
Message-ID: <CAB=NE6V1h7x=YNa6DX8LoEY9otvVNaek=C91qoj60pYe51R2=w@mail.gmail.com> (sfid-20120806_213919_790849_3F4F757A)
Subject: Re: [PATCH] compat-wireless: Fix another $HOME glitch, unify file lists
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
Cc: mcgrof@kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 6, 2012 at 12:05 PM, Ozan Çağlayan <ozancag@gmail.com> wrote:
> - Drop duplicate lines in WSTABLE,
> - Do not call mkdir -p for a second time,
> - Fix another $USER/$HOME glitch.
>
> Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>

Applied and pushed, thanks!

  Luis
