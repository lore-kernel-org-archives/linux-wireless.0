Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51163 "EHLO sipsolutions.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751749AbaJ0LVT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2014 07:21:19 -0400
Message-ID: <1414408856.3836.3.camel@jlt4.sipsolutions.net> (sfid-20141027_122122_960841_6E074522)
Subject: Re: [PATCH 0/3] Add mcast event when hwsim radios are created and
 removed
From: Johannes Berg <johannes@sipsolutions.net>
To: Jukka Rissanen <jukka.rissanen@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 27 Oct 2014 12:20:56 +0100
In-Reply-To: <1414406688-3827-1-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141027_114536_599448_FF2C1C5E)
References: <1414406688-3827-1-git-send-email-jukka.rissanen@linux.intel.com>
	 (sfid-20141027_114536_599448_FF2C1C5E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-10-27 at 12:44 +0200, Jukka Rissanen wrote:
> Hi,
> 
> patch 1 renames HWSIM_CMD_CREATE_RADIO to HWSIM_CMD_NEW_RADIO and
> HWSIM_CMD_DESTROY_RADIO to HWSIM_CMD_DEL_RADIO. They are more
> fitting on how other pieces of the wireless system work. A define
> to old name is provided for backward compatibility.

That seems reasonable, if a little gratuitous.

> Patches 2 and 3 use the newly named enums and provide a way to inform
> the listeners on the multicast group "config" when new radio is created
> and existing radio is deleted.

Why bother? There are nl80211 events for this already, no?

johannes

