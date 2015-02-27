Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60599 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbbB0Q4S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2015 11:56:18 -0500
Message-ID: <1425056171.1960.8.camel@sipsolutions.net> (sfid-20150227_175622_792919_6CD60E4B)
Subject: Re: [PATCH] nl80211: add notes about userspace API/ABI modifications
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi
Date: Fri, 27 Feb 2015 17:56:11 +0100
In-Reply-To: <54F0A0CB.2050804@broadcom.com>
References: <1425047563-9988-1-git-send-email-johannes@sipsolutions.net>
	 <54F0A0CB.2050804@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-02-27 at 17:52 +0100, Arend van Spriel wrote:
> On 02/27/15 15:32, Johannes Berg wrote:
> > From: Johannes Berg<johannes.berg@intel.com>
> >
> > Add notes about userspace ABI/API modifications, including the
> > fact that we decided that API submissions should come with a
> > driver implementation.
> 
> Should we also consider Cc: to linux-api mailing list or do you think 
> nl80211 api has sufficient capable reviewers.

Well, I don't know for sure, but I'd rather not overload the people
there ... there are very few there anyway. And probably most people have
no idea what wifi is ;-)

> There is probably a reason 
> for adding these notes now ;-)

Well, that's mostly the discussion on "need to have an upstream user"

johannes

