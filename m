Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbXDIBKH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Apr 2007 21:10:07 -0400
Subject: Re: Is it possible to test ipw2200 / mac80211 in 2.6.21-rc6-mm1?
From: Dan Williams <dcbw@redhat.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <a44ae5cd0704081723q5b66baa8u23d2dda6d7ac0c91@mail.gmail.com>
References: <a44ae5cd0704081723q5b66baa8u23d2dda6d7ac0c91@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 08 Apr 2007 21:13:47 -0400
Message-Id: <1176081227.4025.3.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2007-04-08 at 20:23 -0400, Miles Lane wrote:
> Hello,
> 
> I notice that mac80211 is in Andrew's tree, but I don't seem to be
> able to build ipw2200 without including the current softmac stuff.
> I'd like to test the mac80211 code.  Is there a way to do this for
> ipw2200 currently?  Do I have to use one of the development git trees?

I don't believe that ipw2200 is a mac80211-based driver.  Unless the
Intel guys rewrote it to be based on mac80211, which would be awesome.

Dan


