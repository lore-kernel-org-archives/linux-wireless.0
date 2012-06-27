Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41907 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab2F0OGX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 10:06:23 -0400
Message-ID: <1340805979.11012.34.camel@jlt3.sipsolutions.net> (sfid-20120627_160627_169084_2A109296)
Subject: Re: 3.4.x bug with channel type changes
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@chromium.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	manschwetus@googlemail.com
Date: Wed, 27 Jun 2012 16:06:19 +0200
In-Reply-To: <1340805097.11012.24.camel@jlt3.sipsolutions.net> (sfid-20120627_155146_490557_390B90C9)
References: <1340805097.11012.24.camel@jlt3.sipsolutions.net>
	 (sfid-20120627_155146_490557_390B90C9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-27 at 15:51 +0200, Johannes Berg wrote:

> Now, the reason I'm writing all this in an email and not a commit log is
> that I don't know what the TX/RX channel type usage should be, or if
> maybe it should be "if (queues_stopped) wake_queues()" or something like
> that... Can you tell me what it should be?

Something like this should help, of course, but maybe there are other
issues in this area too?

http://p.sipsolutions.net/3e89ee42463d6cc9.txt

johannes

