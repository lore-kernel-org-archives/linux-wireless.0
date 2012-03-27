Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707Ab2C0MjF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 08:39:05 -0400
Date: Tue, 27 Mar 2012 14:38:24 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Chen, Chien-Chia" <machen@suse.com>
Cc: IvDoorn@gmail.com, helmut.schaa@googlemail.com,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] [PATCH] rt2x00: rt2x00dev: move rfkill_polling
 register to proper place
Message-ID: <20120327123822.GA2565@redhat.com> (sfid-20120327_143909_531455_7D40AAD7)
References: <1332829680-32457-1-git-send-email-machen@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1332829680-32457-1-git-send-email-machen@suse.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 27, 2012 at 02:28:00PM +0800, Chen, Chien-Chia wrote:
> Move rt2x00rfkill_register(rt2x00dev) to rt2x00lib_probe_dev().
> It fixes of starting rfkill_poll function at the right time if
> sets hard rfkill block and reboot. rt2x00mac_rfkill_poll should
> be starting before bringing up the wireless interface.
> 
> Signed-off-by: Kevin Chou <kevin.chou@mediatek.com>
You should sign off the patch, and probably add "From:" to mark real
author of the patch, and CC Kevin as well.

Stanislaw
