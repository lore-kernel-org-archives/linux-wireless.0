Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45301 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab2F1Jih (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 05:38:37 -0400
Message-ID: <1340876313.4491.30.camel@jlt3.sipsolutions.net> (sfid-20120628_113841_197491_60515BF9)
Subject: Re: [PATCH v2] mac80211: flush queues before deauth/disassoc
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 28 Jun 2012 11:38:33 +0200
In-Reply-To: <1340795902-12334-1-git-send-email-eliad@wizery.com> (sfid-20120627_131813_916740_3933409B)
References: <1340795902-12334-1-git-send-email-eliad@wizery.com>
	 (sfid-20120627_131813_916740_3933409B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-27 at 14:18 +0300, Eliad Peller wrote:
> On deauth/disassoc we tear down all BA sessions. These
> DELBA packets are sent on the appropriate TID, while
> deauth/disassoc is always sent on VO. This sometimes
> ends with the DELBA being sent after the deauth was
> already sent.
> 
> Fix it by flushing all the pending frames before
> sending deauth/disassoc.

Applied.

johannes

