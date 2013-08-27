Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891Ab3H0IBz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 04:01:55 -0400
Date: Tue, 27 Aug 2013 10:00:02 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Paul Menzel <paulepanter@users.sourceforge.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Fabien ADAM <id2ndr@crocobox.org>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 3.11] rt2800: fix wrong TX power
 compensation
Message-ID: <20130827080001.GA2609@redhat.com> (sfid-20130827_100157_688743_F20E981C)
References: <20130826131851.GB10525@redhat.com>
 <1377548398.4408.4.camel@mattotaupa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1377548398.4408.4.camel@mattotaupa>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 26, 2013 at 10:19:58PM +0200, Paul Menzel wrote:
> Could you please add which ones you have tested?

I checked 2 devices (3071 & 3070) but they have EXTERNAL_TX_ALC bit set.
I assume the fix is correct based on vendor driver and it fixes devices
which have no EXTERNAL_TX_ACL, but I can not tell what chipset that are.
Is possible that the same chipset can be configured with and without
EXTERNAL_TX_ALC.

> Is there a bug report about this?

Fabien reported problem on mailing list, I can add that as reference.
I hope it also fixes bug reported here:
https://bugzilla.redhat.com/show_bug.cgi?id=913631
but I haven't get confirmation about that from users yet.

Stanislaw

