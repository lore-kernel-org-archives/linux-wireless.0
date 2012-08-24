Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13028 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780Ab2HXQ6J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2012 12:58:09 -0400
From: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>
To: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: RE: [RFC 1/3] ath9k: Fix BTCOEX timer triggering comparision
Date: Fri, 24 Aug 2012 16:58:02 +0000
Message-ID: <8F3AF1C9F856774F8C8D67AA7EDFEC8801EEB120@aphydexd01b> (sfid-20120824_185813_542370_8C8DAE9E)
References: <1345817851-8700-1-git-send-email-mohammed@qca.qualcomm.com>,<20120825153919.GA23173@kamboji.qca.qualcomm.com>
In-Reply-To: <20120825153919.GA23173@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 24, 2012 at 07:47:29PM +0530, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>
> Its safer to convert btcoex_period to 'us' while
> comparing with btcoex_no_stomp which is in 'us'.
> Did not find any functionality issues being fixed,
> as the generic hardware timer triggers are usually
> refreshed with the newer duty cycle.
>
In which way it is safer? What does the patch fix? It was intentionally
converted to msec by "ath9k: keep btcoex period in milliseconds".

-Rajkumar
