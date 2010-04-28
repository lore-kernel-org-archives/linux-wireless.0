Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48287 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab0D1N7U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 09:59:20 -0400
Subject: Re: [PATCH 2/2] mac80211: fix supported rates IE if AP doesn't
 give us it's rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20100428155755.75f1dc5a@dhcp-lab-109.englab.brq.redhat.com>
References: <1272460624-3611-1-git-send-email-sgruszka@redhat.com>
	 <1272460624-3611-2-git-send-email-sgruszka@redhat.com>
	 <1272461964.3565.21.camel@jlt3.sipsolutions.net>
	 <20100428155755.75f1dc5a@dhcp-lab-109.englab.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Apr 2010 15:59:17 +0200
Message-ID: <1272463157.3565.22.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-04-28 at 15:57 +0200, Stanislaw Gruszka wrote:
> On Wed, 28 Apr 2010 15:39:24 +0200
> Johannes Berg <johannes@sipsolutions.net> wrote:
> 
> > Could you add a comment about what AP this is
> 
> Bug reporter don't know what AP it is. He fail to connect
> to wireless network at school.
> https://bugzilla.redhat.com/show_bug.cgi?id=558002

Ah bugger.

> >, and that it's a
> > workaround please?
> 
> I don't think this is workaround. For me this is right behavior
> and fix for workaround introduced in commit
> 36d16ae73becc5978fe22866e9ab66b509211afe "mac80211: fix association
> with some APs"

Oh yeah so it's a workaround for a workaround. Oh well. Can we still
have a comment about it in the else branch?

johannes

