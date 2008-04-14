Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925AbYDNP5i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2008 11:57:38 -0400
Subject: Re: mac80211 question
From: Dan Williams <dcbw@redhat.com>
To: Dad <ccmcphe@verizon.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <48037A8E.5050200@verizon.net>
References: <48037A8E.5050200@verizon.net>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 11:54:48 -0400
Message-Id: <1208188488.31015.34.camel@localhost.localdomain> (sfid-20080414_165741_917083_678D590D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-04-14 at 11:38 -0400, Dad wrote:
> Are there any plans to include the nickname into mac80211? I noticed 
> that the version I have the ioctl's for nickname are
> NULL'ed out.

Any particular reason you want nickname?  AFAIK it was only used for
compat with pre-802.11 stuff like WaveLAN and such.  It's pretty much
useless these days.  Some drivers used it to signal whether they were
connected or not, but that's a completely bogus use of nickname and not
something that mac80211 should support.

Dan

