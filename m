Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58469 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1AJHMB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 02:12:01 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net
Subject: ath9k:  Resend all my pending patches.
Date: Sun,  9 Jan 2011 23:11:42 -0800
Message-Id: <1294643513-18820-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here is my current ath9k patch queue.  These have all been
posted before, but this should make it easier to apply them.

The final 'copy-break' patch still needs some work to
function properly on non PCI busses it seems, and maybe
disable copybreak on larger packets.

