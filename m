Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36616 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759759Ab0JFSsm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 14:48:42 -0400
Subject: Re: Any /n NICs that support APs and multiple STAs other than
 ath9k?
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTimB7=odPK3qTAhFBdzaMFFGVar0kyMrb-p9SgYy@mail.gmail.com>
References: <4CACA3D7.90108@candelatech.com>
	 <AANLkTimB7=odPK3qTAhFBdzaMFFGVar0kyMrb-p9SgYy@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 20:48:40 +0200
Message-ID: <1286390920.3655.402.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-06 at 11:45 -0700, Luis R. Rodriguez wrote:

> Your best bet is to test against mac80211_hwsim, that would rule out
> any hardware. I think Jouni and Johannes have also a way to get the
> devices to talk to each other. Perhaps some documentation of that on
> the kernel Documentation/networking/mac80211_hwsim/

You can either use network namespaces, or you can now somehow add local
routes (Patrick worked on that). But that's only needed if you need to
test IP connectivity at all between the interfaces, as long as you just
assoc etc. you don't need that.

johannes

