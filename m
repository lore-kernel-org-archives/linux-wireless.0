Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41821 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671Ab2EBSRs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2012 14:17:48 -0400
Date: Wed, 2 May 2012 14:12:29 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: mesh: Remove un-needed defines
Message-ID: <20120502181229.GD9285@tuxdriver.com> (sfid-20120502_201752_968581_54FBCE0D)
References: <1335472901-12323-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
 <CAG6hwVPx5OSJXAz8Kj-=zDbP8MWUaUKJL1VFtyjZVaQ5Jk_6_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAG6hwVPx5OSJXAz8Kj-=zDbP8MWUaUKJL1VFtyjZVaQ5Jk_6_g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 26, 2012 at 02:41:32PM -0700, Thomas Pedersen wrote:
> Hi Andrei,
> 
> On Thu, Apr 26, 2012 at 1:41 PM, Andrei Emeltchenko
> <Andrei.Emeltchenko.news@gmail.com> wrote:
> > From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
> >
> > ieee80211_vif_is_mesh is already defined as:
> >
> > <------8<--------------------------------------------------------------
> > |  static inline bool ieee80211_vif_is_mesh(struct ieee80211_vif *vif)
> > |  {
> > |  #ifdef CONFIG_MAC80211_MESH
> > |          return vif->type == NL80211_IFTYPE_MESH_POINT;
> > |  #endif
> > |          return false;
> > |  }
> > |
> > <------8<--------------------------------------------------------------
> >
> > Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@intel.com
> 
> ACK if you tested w/o CONFIG_MAC80211_MESH.

Well...did you??

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
