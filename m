Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0109.hostedemail.com ([216.40.44.109]:47735 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932071AbaJHM0P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 08:26:15 -0400
Message-ID: <1412771171.3438.25.camel@joe-AO725> (sfid-20141008_142620_222419_D17CFD5E)
Subject: Re: [patch] staging: rtl8723au: incorrect use of ether_addr_copy()
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	kernel-janitors@vger.kernel.org
Date: Wed, 08 Oct 2014 05:26:11 -0700
In-Reply-To: <20141008104014.GA23096@mwanda>
References: <20141008104014.GA23096@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-10-08 at 13:40 +0300, Dan Carpenter wrote:
> The return from myid() isn't aligned correctly for ether_addr_copy().

Hey Dan.

Actual evidence showing ether_addr_copy conversions
may not always be wise.

How did you find them?

Is there a new alignment capability in smatch?


