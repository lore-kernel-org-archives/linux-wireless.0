Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58514 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbbAFKLM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 05:11:12 -0500
Message-ID: <1420539068.1966.8.camel@sipsolutions.net> (sfid-20150106_111114_923161_183F6A1B)
Subject: Re: [PATCH 1/2] cfg80211: Add API to change the indoor regulatory
 setting
From: Johannes Berg <johannes@sipsolutions.net>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@suse.com,
	ArikX Nemtsov <arik@wizery.com>
Date: Tue, 06 Jan 2015 11:11:08 +0100
In-Reply-To: <1420338556-11901-1-git-send-email-ilan.peer@intel.com> (sfid-20150104_092713_237890_C4245926)
References: <1420338556-11901-1-git-send-email-ilan.peer@intel.com>
	 (sfid-20150104_092713_237890_C4245926)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-01-03 at 21:29 -0500, Ilan Peer wrote:
> As the operating environment of a device can change, add
> API for user space to indicate a change of indoor settings.
> In addition modify the handling of the indoor processing as
> follows:
> 
> 1. Directly update the indoor setting without wrapping it as a
>    regulatory request.
> 2. Track the socket on which the indoor hint is issued, and reset
>    indoor setting if the socket was released.
> 3. Do not reset the indoor setting when restoring the regulatory
>    settings as it has nothing to do with CRDA or interface
>    disconnection.
> 
> Signed-off-by: Ilan Peer <ilan.peer@intel.com>
> Signed-off-by: ArikX Nemtsov <arik@wizery.com>

This doesn't apply on mac80211-next. Also, you should sign off after
Arik (and how did he manage to get that X there?)

johannes

