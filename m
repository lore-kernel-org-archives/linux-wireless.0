Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:35882 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbYKXGPI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 01:15:08 -0500
Message-ID: <1205.94.79.146.217.1227505499.squirrel@webmail.madwifi.org> (sfid-20081124_071514_224762_60872498)
In-Reply-To: <492A14A7.4040808@gmail.com>
References: <492A14A7.4040808@gmail.com>
Date: Mon, 24 Nov 2008 06:44:59 +0100 (CET)
Subject: Re: [Fwd: please don't regress ath5k.h]
From: "Michael Renzmann" <mrenzmann@madwifi-project.org>
To: "Richard Farina" <sidhayn@gmail.com>
Cc: "wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

Richard Farina wrote:
> I recently saw this additional comment added to wireless-testing.git and
> it has me a bit concerned.  I use this feature for a specific patch set
> that I maintain and it would break it pretty bad to remove this.

Just an idea: what prevents you to add a patch to that patchset that
reenables the amount of code you require from the CHAN_DEBUG stuff should
it be removed upstream?

Bye, Mike
