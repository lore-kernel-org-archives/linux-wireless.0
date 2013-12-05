Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52624 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab3LEQPG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 11:15:06 -0500
Message-ID: <1386260099.4182.16.camel@jlt4.sipsolutions.net> (sfid-20131205_171511_138218_0B1C1FA1)
Subject: Re: [PATCH 4/4] cfg80211: prevent race condition on scan request
 cleanup
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 05 Dec 2013 17:14:59 +0100
In-Reply-To: <CAB3XZEc4pikahyAmPCh_pCjFEiRvFgAyZgxGrbH9A6hLP2nhFw@mail.gmail.com> (sfid-20131205_163919_049659_09596AAD)
References: <1386235289-27278-1-git-send-email-eliad@wizery.com>
	 <1386235289-27278-4-git-send-email-eliad@wizery.com>
	 <1386253879.4182.4.camel@jlt4.sipsolutions.net>
	 <CAB3XZEcpM9PAQCGQ99X2A-bqYXoPEmE=Cg29CDKY7=s8QquwUA@mail.gmail.com>
	 <1386254607.4182.5.camel@jlt4.sipsolutions.net>
	 <CAB3XZEc4pikahyAmPCh_pCjFEiRvFgAyZgxGrbH9A6hLP2nhFw@mail.gmail.com>
	 (sfid-20131205_163919_049659_09596AAD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-12-05 at 17:39 +0200, Eliad Peller wrote:

> > Btw, should any of this go to 3.13?
> maybe the first one. it's the only "real" issue.

Actually, I'm not going to take that into 3.13 - we defined the API so
that the driver is always allowed to drop the scheduled scan, this isn't
really any different, is it?

johannes

