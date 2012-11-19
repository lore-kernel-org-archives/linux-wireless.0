Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36665 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab2KSOpB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 09:45:01 -0500
Message-ID: <1353336331.18299.15.camel@jlt4.sipsolutions.net> (sfid-20121119_154505_876650_120DB75E)
Subject: Re: [PATCH v2] mac80211: support radiotap vendor namespace RX data
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org, nabhinav3@mail.gatech.edu
Date: Mon, 19 Nov 2012 15:45:31 +0100
In-Reply-To: <1353063966.9490.1.camel@jlt4.sipsolutions.net> (sfid-20121116_120541_594339_E0331937)
References: <1353061591-22284-1-git-send-email-johannes@sipsolutions.net>
	 <87ehjtygci.fsf@purkki.adurom.net>
	 <1353063966.9490.1.camel@jlt4.sipsolutions.net>
	 (sfid-20121116_120541_594339_E0331937)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-16 at 12:06 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In some cases, in particular for experimentation, it
> can be useful to be able to add vendor namespace data
> to received frames in addition to the normal radiotap
> data.
> 
> Allow doing this through mac80211 by adding fields to
> the RX status descriptor that describe the data while
> the data itself is prepended to the frame.
> 
> Also add some example code to hwsim, but don't enable
> it because it doesn't use a proper OUI identifier.

Applied.

johannes

