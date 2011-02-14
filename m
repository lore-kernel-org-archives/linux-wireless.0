Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60694 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab1BNKVg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 05:21:36 -0500
Subject: Re: [PATCH 1/7] mac80211:  Make STA disconnect messages warn
 instead of debug.
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@adurom.com>
Cc: greearb@candelatech.com, linux-wireless@vger.kernel.org
In-Reply-To: <87y65q7hc3.fsf@purkki.adurom.net>
References: <1297115078-27773-1-git-send-email-greearb@candelatech.com>
	 <87y65q7hc3.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 11:21:32 +0100
Message-ID: <1297678892.3785.21.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-02-08 at 16:04 +0200, Kalle Valo wrote:
> greearb@candelatech.com writes:
> 
> > From: Ben Greear <greearb@candelatech.com>
> >
> > This makes them more easily seen in /var/log/messages
> > and the console, for instance.
> 
> Messages like these are in the category "business as usual", which
> happens frequently when the device is moved. IMHO they are not really
> warnings. I'm worried that making the messages more visible might
> scare the users too much.

I agree -- this will happen all the time unless you have a really really
good roaming algorithm or never move around.

johannes

