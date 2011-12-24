Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33696 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab1LXPbe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Dec 2011 10:31:34 -0500
Subject: Re: [PATCH 0/3] notify driver about changes in station state
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1324643075-29385-1-git-send-email-eliad@wizery.com> (sfid-20111223_132353_535546_D11D4E4D)
References: <1324643075-29385-1-git-send-email-eliad@wizery.com>
	 (sfid-20111223_132353_535546_D11D4E4D)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 24 Dec 2011 16:31:31 +0100
Message-ID: <1324740691.6872.1.camel@jlt3.sipsolutions.net> (sfid-20111224_163152_876838_256B2427)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-12-23 at 14:24 +0200, Eliad Peller wrote:
> This patchset is a sequel for Johannes' "station management rework"
> patchset. It adds a new sta_state callback, so low-level driver
> will be able to register for station state changes.

The only comment I have here is that I think structurally it would be
preferable to also call this when a station is uploaded, so the driver
doesn't have to check the state it's uploaded in. Or maybe not?

johannes

