Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:18490 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761471AbZDHH0P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 03:26:15 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: don't leak skb on receive error
Date: Wed, 8 Apr 2009 09:26:02 +0200
Cc: Philip Rakity <prakity@yahoo.com>,
	libertas-dev@lists.infradead.org, stable@vger.kernel.org
References: <422915.71719.qm@web58908.mail.re1.yahoo.com>
In-Reply-To: <422915.71719.qm@web58908.mail.re1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200904080926.02727.hs4233@mail.mn-solutions.de> (sfid-20090408_092622_566434_12108EE0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Don't lead memory when receive errors
> Signed-off-by: Philip Rakity <prakity@yahoo.com>

Looks fine from my site (the libertas-if_cs-guy).
