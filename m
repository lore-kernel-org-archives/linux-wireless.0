Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39987 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755206AbaKSRh6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 12:37:58 -0500
Message-ID: <1416418675.9374.7.camel@sipsolutions.net> (sfid-20141119_183801_176791_907A5671)
Subject: Re: [PATCH] mac80211: don't allow 40MHz tx rates in case of 20MHz
 chandef
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>
Date: Wed, 19 Nov 2014 18:37:55 +0100
In-Reply-To: <1415722282-29309-1-git-send-email-egrumbach@gmail.com> (sfid-20141111_171131_662829_319984B9)
References: <1415722282-29309-1-git-send-email-egrumbach@gmail.com>
	 (sfid-20141111_171131_662829_319984B9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-11-11 at 18:11 +0200, Emmanuel Grumbach wrote:
> From: Eliad Peller <eliad@wizery.com>
> 
> When 20MHz chandef is used, 40MHz rates shouldn't be
> used (by the rate-control algorithm), even if the sta
> ht capabilities indicate support for it.

Applied. If we need to backport it please send it to stable once it hits
mainline.

johannes

