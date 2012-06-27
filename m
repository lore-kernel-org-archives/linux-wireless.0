Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41381 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab2F0LRx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 07:17:53 -0400
Message-ID: <1340795869.11012.12.camel@jlt3.sipsolutions.net> (sfid-20120627_131757_137247_ABE3E96B)
Subject: Re: mac80211 auth/assoc in multi-channel scenarios
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: Eliad Peller <eliad@wizery.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 27 Jun 2012 13:17:49 +0200
In-Reply-To: <CA+XVXffLy5mSqXTtEh7STC_xtSKOJTdtVF9jGPj5UEQ88wD+LQ@mail.gmail.com> (sfid-20120626_133531_465169_24BA84E2)
References: <1340640308.27437.16.camel@jlt3.sipsolutions.net>
	 <CAB3XZEe7t3MYVv6Bja9X315CuhWa=aaEyB82pGp_9hMp8grbMg@mail.gmail.com>
	 <1340707305.14634.9.camel@jlt3.sipsolutions.net>
	 <CAB3XZEfEB2TaeN4EYGyBmcuh823EfmdLhSWE55u5OwPE+Ff7oQ@mail.gmail.com>
	 <CA+XVXffLy5mSqXTtEh7STC_xtSKOJTdtVF9jGPj5UEQ88wD+LQ@mail.gmail.com>
	 (sfid-20120626_133531_465169_24BA84E2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-26 at 14:35 +0300, Arik Nemtsov wrote:

> Can you give a bit more info on the Tx-sync approach, for the uninitiated?
> I'm also thinking that maybe we could somehow treat the sleeping-GO as
> a special case (maybe with some special code and a HW flag). Right now
> I'm not sure the wl12xx FW even supports it.

I basically had a simpler version in mind, something like this:
http://p.sipsolutions.net/cd928e926a941ac7.txt

johannes

