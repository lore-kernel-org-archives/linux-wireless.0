Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47606 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbaEWJxH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 05:53:07 -0400
Message-ID: <1400838772.4358.22.camel@jlt4.sipsolutions.net> (sfid-20140523_115311_454850_185C8848)
Subject: Re: [PATCH] mac80211: add a single-transaction driver op to switch
 contexts
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 23 May 2014 11:52:52 +0200
In-Reply-To: <1400837419.4358.17.camel@jlt4.sipsolutions.net> (sfid-20140523_113031_200744_AC708F4C)
References: <1400769938.4174.29.camel@jlt4.sipsolutions.net>
	 <1400812703-15685-1-git-send-email-luca@coelho.fi>
	 <CA+BoTQkof_e_T=xegftVHdKK_XFeb2HegOQWmV5+PkCdLkzEyg@mail.gmail.com>
	 (sfid-20140523_100116_761277_D988CC7D) <1400835498.4358.9.camel@jlt4.sipsolutions.net>
	 <1400836483.25946.37.camel@dubbel>
	 <1400837419.4358.17.camel@jlt4.sipsolutions.net>
	 (sfid-20140523_113031_200744_AC708F4C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-05-23 at 11:30 +0200, Johannes Berg wrote:

> > Also, my patch *does* support multiple vifs.  But the code we have
> > doesn't support it, so I call the new op with a single-vif only.
> > Michal's patch doesn't call the new op (only on a later patch), so it's
> > pretty much the same.
> 
> Right, ok. So it's a wash. Flip a coin? :)

Looks like Luca's patch needs less work, so let's go with that?

johannes

