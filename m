Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3.dnainternet.fi ([87.94.96.71]:33525 "EHLO
	smtp3.dnainternet.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbYLXWEc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2008 17:04:32 -0500
Message-ID: <20081224235752.31212fodqucyu0lc@hayate.ip6> (sfid-20081224_230439_412942_16404F50)
Date: Wed, 24 Dec 2008 23:57:52 +0200
From: "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>
To: "David Kilroy" <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org, simon@thekelleys.org.uk,
	acme@ghostprotocols.net, pe1rxq@amsat.org
Subject: Re: [PATCH] wireless: Add channel/frequency conversions to
	ieee80211.h
References: <1230041018-13341-1-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1230041018-13341-1-git-send-email-kilroyd@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting "David Kilroy" <kilroyd@googlemail.com>:

> Added mappings for FHSS, DSSS and OFDM channels - with macros to point
> HR DSSS and ERP to the DSSS mappings. Currently just static inline
> functions.
>
> Use the new functions in the older fullmac drivers. This eliminates a
> number of const static buffers and removes a couple of range checks that
> are now redundant.
>
> Signed-off-by: David Kilroy <kilroyd@googlemail.com>

rndis_wlan part looks ok to me.

Acked-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

