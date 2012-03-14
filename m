Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030750Ab2CNKcH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 06:32:07 -0400
Date: Wed, 14 Mar 2012 11:31:52 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	IvDoorn@gmail.com, gwingerde@gmail.com
Subject: Re: [PATCH] rt2x00: Set IEEE80211_HW_REPORTS_TX_ACK_STATUS in rt2800
Message-ID: <20120314103151.GA18005@redhat.com> (sfid-20120314_113212_462528_6DC26AD1)
References: <1331711807-32680-1-git-send-email-helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1331711807-32680-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 14, 2012 at 08:56:47AM +0100, Helmut Schaa wrote:
> rt2800 already reports the tx ack status of each frame back to mac80211.
> Advertise this by setting IEEE80211_HW_REPORTS_TX_ACK_STATUS for rt2800.
> This allows some mac80211 features like frame loss notifications to work
> with rt2800.
> 
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---
> 
> I don't see a problem with enabling this for rt2800pci.
> Ivo, Gertjan, Stanislaw, any objection against enabling for rt2800usb?

I did short testings and did not found any problems.

Stanislaw
