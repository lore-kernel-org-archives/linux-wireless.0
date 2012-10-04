Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2280 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933406Ab2JDQ2C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2012 12:28:02 -0400
Message-ID: <506DB904.9000002@broadcom.com> (sfid-20121004_182808_711686_346043AC)
Date: Thu, 4 Oct 2012 18:27:48 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <dan.carpenter@oracle.com>
cc: "Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Pieter-Paul Giesberts" <pieterpg@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch 3/3] brcmfmac: Using zero instead of NULL
References: <20121003060713.GC3802@elgon.mountain>
In-Reply-To: <20121003060713.GC3802@elgon.mountain>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/03/2012 08:07 AM, Dan Carpenter wrote:
> Sparse complains that we use zero instead of NULL here.  In fact, the
> initialization is wrong and should be removed.  Doing these kinds of
> bogus initializations means that GCC can't detect unitialized variables
> and leads to bugs.

We already had it fixed internally, but your change is more sensible. I 
had it reviewed internally and plan to send it to John for 3.8 (ie. 
wireless-next after merge window). Let me know if that is ok with you.

Gr. AvS

