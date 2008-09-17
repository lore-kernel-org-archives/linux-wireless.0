Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:44560 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbYIQWGM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 18:06:12 -0400
Received: by py-out-1112.google.com with SMTP id p76so2564249pyb.10
        for <linux-wireless@vger.kernel.org>; Wed, 17 Sep 2008 15:06:11 -0700 (PDT)
Message-ID: <69e28c910809171506o3ed21d2bucfbbc616d5472e6e@mail.gmail.com> (sfid-20080918_000615_624704_D81FC910)
Date: Thu, 18 Sep 2008 00:06:10 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: iw packaging
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Davide Pesavento" <davidepesa@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890809171503i50bd86d5h5adef88f6214ef27@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1221596962.9262.12.camel@johannes.berg>
	 <1221649638.9262.50.camel@johannes.berg>
	 <48D0E5CE.8050401@le-vert.net>
	 <1221650286.9262.57.camel@johannes.berg>
	 <69e28c910809171319r30d763cse24744a198e41f92@mail.gmail.com>
	 <1221683467.7412.6.camel@localhost>
	 <2da21fe50809171446y56cd5b2ctc864650be6030621@mail.gmail.com>
	 <1221688366.7412.13.camel@localhost>
	 <69e28c910809171458q70763189lde2e2710c64fc70c@mail.gmail.com>
	 <43e72e890809171503i50bd86d5h5adef88f6214ef27@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 18, 2008 at 12:03 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> People wanting to test bleeding edge and not compile their own kernel
> simply can use compat-wireless crap and that has its own nl80211.h. We
> can modify iw to let COMPAT_TREE be defined and if so look there
> first. This is what CRDA does for example.
>
> I don't see why packages should ship their own nl80211.h unless you
> are replacing or providing a new cfg80211.ko.
>
>  Luis
>

We want distros to ship iw, and for that we must not require using
extra files from a development repository.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
