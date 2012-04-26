Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35234 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab2DZVlw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 17:41:52 -0400
Received: by iadi9 with SMTP id i9so94858iad.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Apr 2012 14:41:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1335472901-12323-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
References: <1335472901-12323-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Thu, 26 Apr 2012 14:41:32 -0700
Message-ID: <CAG6hwVPx5OSJXAz8Kj-=zDbP8MWUaUKJL1VFtyjZVaQ5Jk_6_g@mail.gmail.com> (sfid-20120426_234156_408666_AC67567F)
Subject: Re: [PATCH] mac80211: mesh: Remove un-needed defines
To: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andrei,

On Thu, Apr 26, 2012 at 1:41 PM, Andrei Emeltchenko
<Andrei.Emeltchenko.news@gmail.com> wrote:
> From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
>
> ieee80211_vif_is_mesh is already defined as:
>
> <------8<--------------------------------------------------------------
> |  static inline bool ieee80211_vif_is_mesh(struct ieee80211_vif *vif)
> |  {
> |  #ifdef CONFIG_MAC80211_MESH
> |          return vif->type == NL80211_IFTYPE_MESH_POINT;
> |  #endif
> |          return false;
> |  }
> |
> <------8<--------------------------------------------------------------
>
> Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@intel.com

ACK if you tested w/o CONFIG_MAC80211_MESH.

Thomas
