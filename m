Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37707 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758201Ab2FZPey (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 11:34:54 -0400
Message-ID: <1340724892.4484.2.camel@jlt3.sipsolutions.net> (sfid-20120626_173457_198817_87EF4E3B)
Subject: Re: [RFC v3 5/7] mac80211: use channel context notifications
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 26 Jun 2012 17:34:52 +0200
In-Reply-To: <4FE9C0B3.5090201@tieto.com>
References: <1340714242-20032-1-git-send-email-michal.kazior@tieto.com>
	  <1340714242-20032-6-git-send-email-michal.kazior@tieto.com>
	 <1340717747.14634.39.camel@jlt3.sipsolutions.net>
	 <4FE9C0B3.5090201@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-26 at 16:01 +0200, Michal Kazior wrote:
> Johannes Berg wrote:
> > On Tue, 2012-06-26 at 14:37 +0200, Michal Kazior wrote:
> >> From: Kazior Michal <Michal.Kazior@tieto.com>
> >
> > In this and a few other patches the From: seems to be wrong?
> 
> The mail server does tricks on me. I'll have to check msmtp config.

No, not the From in the email, the From you put as the first line into
the patch -- if you're using git that comes from the commit author
field.

johannes

