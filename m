Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37832 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab0FHH1a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jun 2010 03:27:30 -0400
Subject: Re: [PATCH v3 1/3] cfg80211: Add nl80211 antenna configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <201006081019.10217.br1@einfach.org>
References: <20100607065858.16060.38448.stgit@tt-desk>
	 <1275901408.3639.2.camel@jlt3.sipsolutions.net>
	 <201006081019.10217.br1@einfach.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Jun 2010 09:27:28 +0200
Message-ID: <1275982048.3706.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-06-08 at 10:19 +0900, Bruno Randolf wrote:

> > > +	res = rdev->ops->get_antenna(&rdev->wiphy, &tx_ant, &rx_ant);
> > > +	if (res)
> > > +		goto free_msg;
> > 
> > and complain about the driver if they still are after this.
> 
> would that be a WARN_ON?

Yeah I suppose so.

johannes

