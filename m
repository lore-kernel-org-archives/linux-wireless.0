Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3117 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157Ab1ITBE3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 21:04:29 -0400
Message-ID: <4E77E68D.7060809@broadcom.com> (sfid-20110920_030432_209964_2A0DF67A)
Date: Mon, 19 Sep 2011 18:04:13 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Joe Perches" <joe@perches.com>, "gregkh@suse.de" <gregkh@suse.de>
cc: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 20/20] staging: brcm80211: reduced checkpatch
 warnings to zero
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
 <1316467568-27683-21-git-send-email-frankyl@broadcom.com>
 <1316477060.27998.4.camel@Joe-Laptop>
In-Reply-To: <1316477060.27998.4.camel@Joe-Laptop>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/19/2011 05:04 PM, Joe Perches wrote:
> Splitting format strings is poor style, makes
> error messages difficult to find via grep and
> is error prone.
>
> You should update your checkpatch version.
> Current checkpatch doesn't warn about this.

Thank you for pointing this out.

> It'd be better if you could find some way
> to reduce the 6 tab indentation rather than
> split 20 char format strings into pieces.

Greg, could you please drop this one? We will take care of the 
indentation issue in future patches.

Thanks,
Franky

