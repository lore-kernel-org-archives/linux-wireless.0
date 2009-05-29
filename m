Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f109.google.com ([209.85.222.109]:39075 "EHLO
	mail-pz0-f109.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbZE2UnR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2009 16:43:17 -0400
Received: by pzk7 with SMTP id 7so4968544pzk.33
        for <linux-wireless@vger.kernel.org>; Fri, 29 May 2009 13:43:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20090529T190620-42@post.gmane.org>
References: <loom.20090529T190620-42@post.gmane.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 29 May 2009 13:42:59 -0700
Message-ID: <43e72e890905291342r17d2fc25kae8fedcc4b938604@mail.gmail.com>
Subject: Re: b43 vs b43legacy
To: Matthieu CASTET <castet.matthieu@free.fr>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 29, 2009 at 12:19 PM, Matthieu CASTET
<castet.matthieu@free.fr> wrote:
> Hi,
>
> what's the difference between b43 and b43legacy ?
>
> From a first point a view, it seems b43 is for core >= 5 and b43legacy for the
> other.
> There is also firmware difference : b43 need v4 and b43legacy need v3.
>
> But v4 firmware seems to support core 4 (pcm4 & ucode4) and b43 code got some
> support for old chips (<5).
>
> Is the split was made because nobody know how to use firmware v4 with core 4 or
> because core 4 it so different from newer core.
> In the latter case why code for older chip (<5) is not removed from the driver ?
>

http://wireless.kernel.org/en/users/Drivers/b43

  Luis
