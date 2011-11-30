Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4322 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab1K3SnA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Nov 2011 13:43:00 -0500
Message-ID: <4ED67925.6040603@broadcom.com> (sfid-20111130_194306_210719_778E2A98)
Date: Wed, 30 Nov 2011 10:42:45 -0800
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <dan.carpenter@oracle.com>,
	"John W. Linville" <linville@tuxdriver.com>
cc: "Arend Van Spriel" <arend@broadcom.com>,
	"Pieter-Paul Giesberts" <pieterpg@broadcom.com>,
	"Alwin Beukers" <alwin@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [patch] brcm80211: fmac: small memory leak on error
References: <20111130084937.GI6268@elgon.mountain>
In-Reply-To: <20111130084937.GI6268@elgon.mountain>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/30/2011 12:49 AM, Dan Carpenter wrote:
> We should free "bus_if" here, it's a small leak but it makes the static
> checkers happy.
>
> Signed-off-by: Dan Carpenter<dan.carpenter@oracle.com>

Thanks, Dan.

Acked-by: Franky Lin <frankyl@broadcom.com>

Franky

