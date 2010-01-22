Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:50027 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838Ab0AVWGU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 17:06:20 -0500
Subject: Re: Starting hostapd causes kernel panic
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Markus Baier <markus_baier@web.de>, linux-wireless@vger.kernel.org,
	kalle.valo@iki.fi
In-Reply-To: <3ef14e53bb12298507dbaec4bb0b98d3.squirrel@secure.sipsolutions.net>
References: <loom.20100122T205326-794@post.gmane.org>
	 <1264193623.2593.17.camel@johannes.local> <1264196526.3040.3.camel@mj>
	 <3ef14e53bb12298507dbaec4bb0b98d3.squirrel@secure.sipsolutions.net>
Content-Type: text/plain
Date: Fri, 22 Jan 2010 17:06:03 -0500
Message-Id: <1264197963.9056.0.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-01-22 at 22:53 +0100, Johannes Berg wrote:
> > I assume it's another case where tx->key should be checked for being
> > NULL.  In fact, it's set to NULL on the preceding line!
> 
> or an else inserted.

Whatever you prefer.  Either way, the panic is fixed now!

-- 
Regards,
Pavel Roskin
