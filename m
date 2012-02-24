Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3132 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609Ab2BXLPT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 06:15:19 -0500
Message-ID: <4F477135.2030804@broadcom.com> (sfid-20120224_121529_393407_5C7051D2)
Date: Fri, 24 Feb 2012 12:15:01 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <dan.carpenter@oracle.com>
cc: "Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Pieter-Paul Giesberts" <pieterpg@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [patch] brcm80211: fmac: fix a couple checking after
 dereference bugs
References: <20120224062226.GA27261@elgon.mountain>
In-Reply-To: <20120224062226.GA27261@elgon.mountain>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/24/2012 07:22 AM, Dan Carpenter wrote:
> There were two dereferencing before checking for NULL static checker
> complaints in this new file.  The list cursor is never NULL so that
> check can be removed.  I moved the other dereference after the check.
>
> Signed-off-by: Dan Carpenter<dan.carpenter@oracle.com>

Acked-by: Arend van Spriel <arend@broadcom.com>

Gr. AvS


