Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2498 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab1ITBNE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 21:13:04 -0400
Message-ID: <4E77E897.9090708@broadcom.com> (sfid-20110920_031317_365275_8DC2C97A)
Date: Mon, 19 Sep 2011 18:12:55 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Joe Perches" <joe@perches.com>
cc: "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 20/20] staging: brcm80211: reduced checkpatch
 warnings to zero
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
 <1316467568-27683-21-git-send-email-frankyl@broadcom.com>
 <1316477060.27998.4.camel@Joe-Laptop>
 <1316480372.30319.1.camel@Joe-Laptop>
In-Reply-To: <1316480372.30319.1.camel@Joe-Laptop>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/19/2011 05:59 PM, Joe Perches wrote:
> On Mon, 2011-09-19 at 17:04 -0700, Joe Perches wrote:
>> It'd be better if you could find some way
>> to reduce the 6 tab indentation rather than
>> split 20 char format strings into pieces.
>
> Perhaps something like this:
>
>   drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |  112 ++++++++++-----------
>   1 files changed, 54 insertions(+), 58 deletions(-)

Indeed we have too many levels of indentations in some functions of 
fullmac. Will clean that up.

Thanks,
Franky

