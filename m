Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57790 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbbEFNyw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2015 09:54:52 -0400
Message-ID: <1430920489.1954.7.camel@sipsolutions.net> (sfid-20150506_155455_386993_A41471E9)
Subject: Re: [PATCH v2] cfg80211: change GO_CONCURRENT to IR_CONCURRENT for
 STA
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 May 2015 15:54:49 +0200
In-Reply-To: <1430918911-14715-1-git-send-email-arik@wizery.com> (sfid-20150506_152835_684182_54AD4C5A)
References: <1430918911-14715-1-git-send-email-arik@wizery.com>
	 (sfid-20150506_152835_684182_54AD4C5A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-05-06 at 16:28 +0300, Arik Nemtsov wrote:
> The GO_CONCURRENT regulatory definition can be extended to station
> interfaces requesting to IR as part of TDLS off-channel operations.
> Rename the GO_CONCURRENT flag to IR_CONCURRENT and allow the added
> use-case.
> 
> Change internal users of GO_CONCURRENT to use the new definition.

Applied.

johannes

