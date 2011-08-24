Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:52071 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab1HXUkA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 16:40:00 -0400
Received: by pzk37 with SMTP id 37so1277374pzk.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 13:40:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110824184453.GK9770@tuxdriver.com>
References: <1313785375-32709-1-git-send-email-javier@cozybit.com> <20110824184453.GK9770@tuxdriver.com>
From: Javier Cardona <javier@cozybit.com>
Date: Wed, 24 Aug 2011 13:39:40 -0700
Message-ID: <CAPjQAd9q-nurAmHdE=mB0OOJrPeObRAxtSJfNDDQg+3MzP+kvg@mail.gmail.com> (sfid-20110824_224004_432382_12DD56CE)
Subject: Re: [PATCH] mac80211: remove mesh paths when an interface is removed
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Thomas Pedersen <thomas@cozybit.com>, devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 24, 2011 at 11:44 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Fri, Aug 19, 2011 at 01:22:55PM -0700, Javier Cardona wrote:
>> When an interface is removed, the mesh paths associated with it should
>> also be removed.
>>
>> This fixes a bug we observed when reloading a device driver module
>> without reloading mac80211s.
>>
>> Signed-off-by: Javier Cardona <javier@cozybit.com>
>
>  CC [M]  net/mac80211/mesh_pathtbl.o
> net/mac80211/mesh_pathtbl.c: In function ‘mpp_path_flush’:
> net/mac80211/mesh_pathtbl.c:862:8: error: invalid type argument of ‘->’ (have ‘rwlock_t’)
> make[1]: *** [net/mac80211/mesh_pathtbl.o] Error 1
> make: *** [net/mac80211/] Error 2

Sorry! I'll include the revised patch in a larger pathset to be
submitted later today.

Cheers,

Javier

-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
