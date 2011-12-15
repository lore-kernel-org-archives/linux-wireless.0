Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3870 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab1LOLuI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 06:50:08 -0500
Message-ID: <4EE9DEE0.9050703@broadcom.com> (sfid-20111215_125012_558049_A0685EDF)
Date: Thu, 15 Dec 2011 12:49:52 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <dan.carpenter@oracle.com>
cc: "Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Pieter-Paul Giesberts" <pieterpg@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [patch] brcm80211: smac: precendence bug in
 wlc_phy_attach()
References: <20111215112332.GA3906@elgon.mountain>
In-Reply-To: <20111215112332.GA3906@elgon.mountain>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/15/2011 12:23 PM, Dan Carpenter wrote:
> Negate has higher precendence than compare and since neither zero nor
> one are equal to four or eight the original condition is always false.
> 

Acked-by: Arend van Spriel <arend@broadcom.com>

> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Gr. AvS

