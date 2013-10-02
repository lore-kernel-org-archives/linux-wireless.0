Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36713 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab3JBQU2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 12:20:28 -0400
Message-ID: <1380730816.13329.28.camel@jlt4.sipsolutions.net> (sfid-20131002_182031_229873_D6EE9781)
Subject: Re: [PATCH v2] mac80211: implement STA CSA for drivers using
 channel contexts
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 02 Oct 2013 18:20:16 +0200
In-Reply-To: <1378044951-13682-1-git-send-email-arik@wizery.com> (sfid-20130901_161614_768170_0FA669D7)
References: <1378044951-13682-1-git-send-email-arik@wizery.com>
	 (sfid-20130901_161614_768170_0FA669D7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-09-01 at 17:15 +0300, Arik Nemtsov wrote:
> Limit the current implementation to a single channel context used by
> a single vif, thereby avoiding multi-vif/channel complexities.
> 
> Reuse the main function from AP CSA code, but move a portion out in
> order to fit the STA scenario.
> 
> Add a new mac80211 HW flag so we don't break devices that don't support
> channel switch with channel-contexts. The new behavior will be opt-in.

Applied, sorry for the delay.

johannes

