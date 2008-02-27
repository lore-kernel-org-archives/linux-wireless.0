Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.232]:33409 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbYB0SdP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2008 13:33:15 -0500
Received: by wr-out-0506.google.com with SMTP id c48so4350448wra.23
        for <linux-wireless@vger.kernel.org>; Wed, 27 Feb 2008 10:33:13 -0800 (PST)
Subject: Re: [PATCH 06/10] mac80211: RCU-ify STA info structure access
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1204111417.3729.52.camel@johannes.berg>
References: <20080225152740.360393000@sipsolutions.net>
	 <20080225153007.340533000@sipsolutions.net>
	 <1203985337.6929.120.camel@localhost>
	 (sfid-20080226_002043_615849_4CE09F20)  <1204014238.13162.201.camel@johannes.berg>
	 <1204054013.6947.18.camel@localhost>
	 (sfid-20080226_192522_572761_6E5854EC)  <1204111417.3729.52.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 10:34:52 -0800
Message-Id: <1204137292.7139.1.camel@localhost> (sfid-20080227_183318_823509_F1D4323D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-02-27 at 12:23 +0100, Johannes Berg wrote:
> Oh. Good point, I missed that one. I suppose that
> mesh_path_node_reclaim() always runs in a context suitable for doing
> del_timer_sync() so it should be fine to just do that there, right? I
> can look into it or leave it to you, just let me know so we don't both
> do it.

I will take care of it.

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


