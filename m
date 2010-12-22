Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39376 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab0LVQNm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 11:13:42 -0500
Received: by iwn9 with SMTP id 9so5364394iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 08:13:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <7F14B85B-566C-45A9-BF8B-FE9DED7944D0@mac.com>
References: <1CA1EE34-CB3D-404D-ADEE-612C8783BFCF@mac.com> <AANLkTin8RZwVrWAdNn_Q+_bX8BAHgKreyHiVjznZtMxU@mail.gmail.com>
 <1A56906E-D786-45E6-9C77-C9D600B508B0@mac.com> <AANLkTikhLKuw56BhDkBUMU-nf8ZYF1v5Berj-+qupAtO@mail.gmail.com>
 <E90F18E9-6332-4A7C-97DA-01169E5BB5E1@mac.com> <AANLkTik6m0rabY3ZCseoch7fwxhMksMD83A-ygtN4cVu@mail.gmail.com>
 <F4DFEC94-D5AC-4C12-890D-8F242E757071@mac.com> <AANLkTi=owvDyO3qfahUwRv4MxJrvMK9hjh5NOwRHQuO+@mail.gmail.com>
 <7F14B85B-566C-45A9-BF8B-FE9DED7944D0@mac.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 22 Dec 2010 11:13:21 -0500
Message-ID: <AANLkTik7jvW9pA3deanBRXxJh6tLeO7WQgqrkN3xa9LG@mail.gmail.com>
Subject: Re: Backporting wl1271 driver to kernel-2.6.32 using compat-wireless
To: Elvis Dowson <elvis.dowson@mac.com>
Cc: "Kahn, Gery" <geryk@ti.com>, Oz Krakowski <ozk@ti.com>,
	Linux Wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 22, 2010 at 11:09 AM, Elvis Dowson <elvis.dowson@mac.com> wrote:
> netdev_alloc_skb_ip_align

I notice you have an android kernel, is that kernel a vanilla kernel
or did it get netdev_alloc_skb_ip_align() cherry picked into it?

  Luis
