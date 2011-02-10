Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51967
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753180Ab1BJTAG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 14:00:06 -0500
Date: Thu, 10 Feb 2011 11:00:40 -0800 (PST)
Message-Id: <20110210.110040.193706322.davem@davemloft.net>
To: helmut.schaa@googlemail.com
Cc: greearb@candelatech.com, linux-wireless@vger.kernel.org
Subject: Re: ath9k and pktgen generate WARNings.
From: David Miller <davem@davemloft.net>
In-Reply-To: <201102101854.41627.helmut.schaa@googlemail.com>
References: <201102100931.38777.helmut.schaa@googlemail.com>
	<4D541E1B.5030707@candelatech.com>
	<201102101854.41627.helmut.schaa@googlemail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>
Date: Thu, 10 Feb 2011 18:54:41 +0100

> Why not make pktgen use the select_queue callback instead?

Because the whole point of what pktgen is doing is to allow the
testing of explicit iteration through the available network queues.
