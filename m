Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:36865 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab2CDWOu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 17:14:50 -0500
Received: by vcqp1 with SMTP id p1so2887571vcq.19
        for <linux-wireless@vger.kernel.org>; Sun, 04 Mar 2012 14:14:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1330774746.3619.2.camel@jlt3.sipsolutions.net>
References: <1330774746.3619.2.camel@jlt3.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Sun, 4 Mar 2012 14:14:29 -0800
Message-ID: <CAG6hwVN7NV2qx6J+wZpgoXm=5VUCXg2Yx8NA1vxs6hNTSUyt+w@mail.gmail.com> (sfid-20120304_231453_423369_8BD165F1)
Subject: Re: mesh smatch (or sparse?) errors
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Javier Cardona <javier@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 3, 2012 at 3:39 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>  CHECK   net/mac80211/mesh_pathtbl.c
> net/mac80211/mesh_pathtbl.c:562 mesh_path_add() error: double lock 'bottom_half:'
> net/mac80211/mesh_pathtbl.c:579 mesh_path_add() error: double unlock 'bottom_half:'
> net/mac80211/mesh_pathtbl.c:588 mesh_path_add() error: double unlock 'bottom_half:'
> net/mac80211/mesh_pathtbl.c:690 mpp_path_add() error: double lock 'bottom_half:'
> net/mac80211/mesh_pathtbl.c:705 mpp_path_add() error: double unlock 'bottom_half:'
> net/mac80211/mesh_pathtbl.c:714 mpp_path_add() error: double unlock 'bottom_half:'
> net/mac80211/mesh_pathtbl.c:812 mesh_path_flush_by_nexthop() error: double lock 'bottom_half:'
> net/mac80211/mesh_pathtbl.c:817 mesh_path_flush_by_nexthop() error: double unlock 'bottom_half:'
> net/mac80211/mesh_pathtbl.c:885 mesh_path_del() error: double lock 'bottom_half:'
> net/mac80211/mesh_pathtbl.c:899 mesh_path_del() error: double unlock 'bottom_half:'
>

I'll take a look, thanks.

Thomas
>
> johannes
>
