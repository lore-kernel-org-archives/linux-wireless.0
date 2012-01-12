Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51461 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab2ALIZm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jan 2012 03:25:42 -0500
Subject: Re: [PATCH 0/8] more station handling refactoring
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20120105153043.568616380@sipsolutions.net> (sfid-20120105_163331_675926_A8C28541)
References: <20120105153043.568616380@sipsolutions.net>
	 (sfid-20120105_163331_675926_A8C28541)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Jan 2012 09:25:37 +0100
Message-ID: <1326356737.3463.0.camel@jlt3.sipsolutions.net> (sfid-20120112_092546_030558_456F1C13)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-01-05 at 16:30 +0100, Johannes Berg wrote:
> Here's another set of patches to refactor station
> handling, particularly station state handling (and
> fix a bug or two in the process).
> 
> The major work here is getting rid of dummy stations
> again and notifying drivers about state transitions
> (but state transition and sta_add/sta_remove callbacks
> will be mutually exclusive).

Eliad identified a few issues here -- John, please drop this patchset,
I'll resend.

johannes

