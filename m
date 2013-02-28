Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55770 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436Ab3B1WQr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2013 17:16:47 -0500
Message-ID: <1362089801.8330.10.camel@jlt4.sipsolutions.net> (sfid-20130228_231650_545957_071BD8BD)
Subject: Re: [PATCH] mac80211: Allow drivers to differentiate between ROC
 types
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>
Date: Thu, 28 Feb 2013 23:16:41 +0100
In-Reply-To: <1361525701-26172-1-git-send-email-johannes@sipsolutions.net> (sfid-20130222_103532_386877_C421CED1)
References: <1361525701-26172-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130222_103532_386877_C421CED1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-22 at 10:35 +0100, Johannes Berg wrote:
> From: Ilan Peer <ilan.peer@intel.com>
> 
> Some devices can handle remain on channel requests differently
> based on the request type/priority. Add support to
> differentiate between different ROC types, i.e., indicate that
> the ROC is required for sending managment frames.

Applied.

johannes

