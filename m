Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47545 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbaEWJa2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 05:30:28 -0400
Message-ID: <1400837419.4358.17.camel@jlt4.sipsolutions.net> (sfid-20140523_113031_200744_AC708F4C)
Subject: Re: [PATCH] mac80211: add a single-transaction driver op to switch
 contexts
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 23 May 2014 11:30:19 +0200
In-Reply-To: <1400836483.25946.37.camel@dubbel>
References: <1400769938.4174.29.camel@jlt4.sipsolutions.net>
	 <1400812703-15685-1-git-send-email-luca@coelho.fi>
	 <CA+BoTQkof_e_T=xegftVHdKK_XFeb2HegOQWmV5+PkCdLkzEyg@mail.gmail.com>
	 (sfid-20140523_100116_761277_D988CC7D) <1400835498.4358.9.camel@jlt4.sipsolutions.net>
	 <1400836483.25946.37.camel@dubbel>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-05-23 at 12:14 +0300, Luca Coelho wrote:

> What do you mean mine doesn't support tracing? Check the bottom of the
> patch again. :) I don't think it's the most beautiful code, but it seems
> to work. :)

Oh, I was going by the old version I guess! :)

That tracing code looks OK to me, though I think that the vif name field
is too short?

> Also, my patch *does* support multiple vifs.  But the code we have
> doesn't support it, so I call the new op with a single-vif only.
> Michal's patch doesn't call the new op (only on a later patch), so it's
> pretty much the same.

Right, ok. So it's a wash. Flip a coin? :)

johannes

