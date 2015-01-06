Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58736 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbbAFK5H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 05:57:07 -0500
Message-ID: <1420541824.1966.19.camel@sipsolutions.net> (sfid-20150106_115711_594708_E184290A)
Subject: Re: [PATCH] mac80211: skip disabled channels in VHT check
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 06 Jan 2015 11:57:04 +0100
In-Reply-To: <1420112597-4035-1-git-send-email-arik@wizery.com> (sfid-20150101_124319_618976_59CFCC95)
References: <1420112597-4035-1-git-send-email-arik@wizery.com>
	 (sfid-20150101_124319_618976_59CFCC95)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-01-01 at 13:43 +0200, Arik Nemtsov wrote:
> The patch "40a11ca mac80211: check if channels allow 80 MHz for VHT
> probe requests" considered disabled channels as VHT enabled, and
> mistakenly sent out probe-requests with the VHT IE.

Applied.

johannes

