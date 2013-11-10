Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:50591 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab3KJUye (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Nov 2013 15:54:34 -0500
Received: by mail-oa0-f50.google.com with SMTP id j17so4484947oag.37
        for <linux-wireless@vger.kernel.org>; Sun, 10 Nov 2013 12:54:33 -0800 (PST)
Date: Sun, 10 Nov 2013 14:32:46 -0600
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>,
	Felipe Contreras <felipe.contreras@gmail.com>
Cc: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	Oleksij Rempel <linux@rempel-privat.de>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Message-ID: <527fed6ec7a4c_1010cd9e844a@nysa.notmuch> (sfid-20131110_215452_032960_C78C12A2)
In-Reply-To: <527FC179.2040503@gmail.com>
References: <CAMP44s1XJRHV8bAX=_-TkSKMkY8Nw1=eHorqTCZ2QmtR5m8uJA@mail.gmail.com>
 <CAMP44s3VRnqw0XJDZTZTym7wBD5-NnfOD56YHbE87OG=3Zan2w@mail.gmail.com>
 <CAMP44s15W7gb8rXwqum5bdHOSk=A_sadX7ksvtkG0qTOu1RREg@mail.gmail.com>
 <CABPxzYLtbs1s-_T+hk+N1hOEuCi_Yq+CGxG7Xx0hPRmiyQM0Jg@mail.gmail.com>
 <CAMP44s0h836BZ+g9-g_t78bKuV_m_xAuvPYRCHaFdJ58eTKthw@mail.gmail.com>
 <CABPxzYJsLqJbJQzr8+2GujQsbJpo922v9ouVWWPbTFL11-UV5g@mail.gmail.com>
 <CAMP44s1ZtTyfKmgy4174ukQU1dwx1Fw=AngNQ=g2Dv2wm4t2-g@mail.gmail.com>
 <CABPxzYKPpL7p0gexV3udgsWYZ_zVYxT6vrz-n-rN36D2AgBCgg@mail.gmail.com>
 <CAMP44s1vwEMRYost99JgLxvXJkFwhgnn9jnYR5RxLPDm-Qj7ug@mail.gmail.com>
 <CABPxzYKQfz2CBvHwWHXT9rSZ6He8ru1R-dP5z+wVy8o3o6L8eQ@mail.gmail.com>
 <CAMP44s2JsVdhRWvkF+jBFns93v7w5kGsP5H83V=CjZr6QynLQA@mail.gmail.com>
 <CABPxzYKA1qCg=nkFL1HsXraBadDei2skBzU4eVxTZ5-e+JSMUA@mail.gmail.com>
 <CANUX_P2+zb0-rU-0ryCnOdxjSkFcSNXJbmJ3B0HtJcnYpsrbQg@mail.gmail.com>
 <CAMP44s0Z1RueHfT_taMSn=sdMyqFXc3hE4HE832qHetXbDhZQQ@mail.gmail.com>
 <527FC179.2040503@gmail.com>
Subject: Re: I always need a miracle to connect with iwlwifi
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach wrote:
> On 11/10/2013 06:26 PM, Felipe Contreras wrote:

> > That's better than not associating at all, ever.
> 
> No because it would break the driver against all the working APs which
> are fortunately enough more common. Maybe you can rewrite mac80211 /
> iwlwifi to make things work differently so that PS would still work with
> good APs and association would work with yours. Fair enough. Go ahead.

Challenge accepted:

http://article.gmane.org/gmane.linux.network/290256

> > Wouldn't it make sense to timeout if there's no DTIM, and still
> > associate? It's better than not associating ever. Plus, if you already
> > know that power saving wouldn't work in this case, merely disable
> > powersave.
> 
> I can't wait for your patch.

Good, because I already sent it.

With my patch if the AP sends the beacon correctly; power saving is enabled, if
not, association still works, but power saving is disabled.

How you could not imagine such patch is beyond me.

-- 
Felipe Contreras
