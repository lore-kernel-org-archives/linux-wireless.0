Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbcFARU2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2016 13:20:28 -0400
Message-ID: <1464801615.4958.6.camel@redhat.com> (sfid-20160601_192032_001317_E1E532F3)
Subject: Re: Where to post Wireless Tools Patches
From: Dan Williams <dcbw@redhat.com>
To: Dibyajyoti Ghosh <dibyajyotig@gmail.com>,
	linux-wireless@vger.kernel.org
Date: Wed, 01 Jun 2016 12:20:15 -0500
In-Reply-To: <CACtQq=bixCDdZpSvj6W+SZKt5N6FSebfgPBjQcqePuj2aN8OAA@mail.gmail.com>
References: <CACtQq=bixCDdZpSvj6W+SZKt5N6FSebfgPBjQcqePuj2aN8OAA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-06-01 at 21:42 +0530, Dibyajyoti Ghosh wrote:
> Hi,
> 
> I want to know the mail id list to send a patch on Wireless Tools.
> Kindly reply ASAP.

Assuming you mean the "wireless-tools" package, this list is OK.  But
probably nobody will apply the patches, since wireless-tools and the
WEXT API are long-since deprecated and haven't been updated in probably
6 or 7 years.  The bar to changes is quite high because of this, even
for trivial ones.

Instead, drivers and userspace tools have moved to the nl80211 APIs to
replace WEXT and the 'iw' tool to replace 'iwconfig'.

Dan
