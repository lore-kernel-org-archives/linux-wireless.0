Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447Ab0D1N4S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 09:56:18 -0400
Date: Wed, 28 Apr 2010 15:57:55 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2/2] mac80211: fix supported rates IE if AP doesn't give
 us it's rates
Message-ID: <20100428155755.75f1dc5a@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <1272461964.3565.21.camel@jlt3.sipsolutions.net>
References: <1272460624-3611-1-git-send-email-sgruszka@redhat.com>
	<1272460624-3611-2-git-send-email-sgruszka@redhat.com>
	<1272461964.3565.21.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 28 Apr 2010 15:39:24 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> Could you add a comment about what AP this is

Bug reporter don't know what AP it is. He fail to connect
to wireless network at school.
https://bugzilla.redhat.com/show_bug.cgi?id=558002

>, and that it's a
> workaround please?

I don't think this is workaround. For me this is right behavior
and fix for workaround introduced in commit
36d16ae73becc5978fe22866e9ab66b509211afe "mac80211: fix association
with some APs"

> The AP is surely supposed to send this information!

The same as we are, no matter what :-)

Cheers
Stanislaw
