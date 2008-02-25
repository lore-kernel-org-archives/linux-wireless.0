Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:36636 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbYBYTav (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 14:30:51 -0500
Received: by ug-out-1314.google.com with SMTP id z38so928264ugc.16
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 11:30:47 -0800 (PST)
Subject: Re: [PATCH 08/13 v2] o11s: other changes in mac80211 for mesh
	interface support
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1203696983.7082.63.camel@johannes.berg>
References: <47be7741.05d6720a.44c4.ffffd0c9@mx.google.com>
	 (sfid-20080222_071830_924260_34482369)  <1203696983.7082.63.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 11:32:25 -0800
Message-Id: <1203967945.6929.17.camel@localhost> (sfid-20080225_193053_260456_A8B137A8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-02-22 at 17:16 +0100, Johannes Berg wrote:
> >  	if (sdata->vif.type != IEEE80211_IF_TYPE_STA &&
> >  	    sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
> > +	    sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT &&
> >  	    sdata->vif.type != IEEE80211_IF_TYPE_AP)
> >  		return -EOPNOTSUPP;
> 
> Why no scanning on mesh interfaces?

? That's actually allowing mesh interfaces to scan.

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


