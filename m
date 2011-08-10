Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34756 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab1HJNlf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 09:41:35 -0400
Subject: Re: [PATCH 5/8] mac80211: mesh gate implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	Javier Cardona <javier@cozybit.com>, linville@tuxdriver.com
In-Reply-To: <1312933511-9486-6-git-send-email-thomas@cozybit.com> (sfid-20110810_014702_231494_868BCEC8)
References: <1312933511-9486-1-git-send-email-thomas@cozybit.com>
	 <1312933511-9486-6-git-send-email-thomas@cozybit.com>
	 (sfid-20110810_014702_231494_868BCEC8)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 15:41:32 +0200
Message-ID: <1312983692.4325.3.camel@jlt3.sipsolutions.net> (sfid-20110810_154138_002891_746FD8AE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 16:45 -0700, Thomas Pedersen wrote:

>  	tbl_mpp->copy_node = &mesh_path_node_copy;
>  	tbl_mpp->mean_chain_len = MEAN_CHAIN_LEN;
> +	/* XXX: not needed */
> +	tbl_mpp->known_gates = kzalloc(sizeof(struct hlist_head), GFP_ATOMIC);
> +	INIT_HLIST_HEAD(tbl_mpp->known_gates);

?

johannes

