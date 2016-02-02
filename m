Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32844 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932526AbcBBPNb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 10:13:31 -0500
Message-ID: <1454426008.2926.10.camel@sipsolutions.net> (sfid-20160202_161334_347336_2893F5DB)
Subject: Re: [PATCH] mac80211: Interoperability workaround for 80+80 and 160
 MHz channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 02 Feb 2016 16:13:28 +0100
In-Reply-To: <1454319655-32170-1-git-send-email-jouni@qca.qualcomm.com>
References: <1454319655-32170-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-02-01 at 11:40 +0200, Jouni Malinen wrote:
> Number of deployed 80 MHz capable VHT stations that do not support
> 80+80
> and 160 MHz bandwidths seem to misbehave when trying to connect to an
> AP
> that advertises 80+80 or 160 MHz channel bandwidth in the VHT
> Operation
> element. To avoid such issues with deployed devices, modify the
> design
> based on recently accepted IEEE 802.11 standard changes (*).
> 
> This allows poorly implemented VHT 80 MHz stations to connect with
> the
> AP in 80 MHz mode. 80+80 and 160 MHz capable stations need to support
> the new workaround mechanism to allow full bandwidth to be used.
> However, there are more or less no impacted station with 80+80/160
> capability deployed.
> 
> The rebased version of this patch is based on the updated version
> from
> Johannes Berg to take the HT/VHT chandef refactoring into account.
> 
Applied.

johannes
