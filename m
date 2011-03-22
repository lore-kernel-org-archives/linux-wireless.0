Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42714 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab1CVVjj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2011 17:39:39 -0400
Subject: Re: [PATCH 1/5 v4] mac80211: Enable mesh security from userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org
In-Reply-To: <1300479732-25920-2-git-send-email-javier@cozybit.com>
References: <1299288252-28314-1-git-send-email-thomas@cozybit.com>
	 <1300479732-25920-2-git-send-email-javier@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Mar 2011 22:39:28 +0100
Message-ID: <1300829968.3746.48.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-03-18 at 13:22 -0700, Javier Cardona wrote:
> Userspace can enable mesh security by providing an RSN IE and setting
> the MESH_SETUP_ENABLE_SECURITY flag.
> 
> Also, rename vendor_ie to just ie to reflect that the same attribute may
> be used to pass other IEs, like for instance RSN.

I still think there should be some sort of advertising about whether or
not secure mesh is support so userspace can actually tell the
difference.

Also, can you do the IE rename thing in a separate patch please?

johannes

