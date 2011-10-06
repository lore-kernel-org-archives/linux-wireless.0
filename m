Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2688 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394Ab1JFJ4S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 05:56:18 -0400
Message-ID: <4E8D7B37.9060605@broadcom.com> (sfid-20111006_115623_478872_35CB8365)
Date: Thu, 6 Oct 2011 11:56:07 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Greg KH" <greg@kroah.com>
cc: "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/15] staging: brcm80211: cleanup fullmac structs
 and softmac srom lookup
References: <1317820814-7083-1-git-send-email-arend@broadcom.com>
 <20111005204705.GA2467@kroah.com>
In-Reply-To: <20111005204705.GA2467@kroah.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/05/2011 10:47 PM, Greg KH wrote:
> On Wed, Oct 05, 2011 at 03:19:59PM +0200, Arend van Spriel wrote:
>> This series addresses more community feedback items received on mainline
>> patch (v2) posted August 25, 2011. The driver structures in brcmfmac could
>> do with some tidying and in the brcmsmac variables loaded from srom were
>> accessed by string identifiers. This has been replaced by enumerated
>> identifiers and the entries are stored in kernel standard linked list.
>>
>> This series applies to staging-next and depends on the patch series posted
>> on Oct 4, 2011 (see Message-ID below).
>>
>> Message-ID:<1317763152-17607-1-git-send-email-arend@broadcom.com>
> All applied, thanks.
>
> greg k-h

Thanks, Greg

That was a speedy integration bringing the staging tree in sync with 
what went in the mainline patch.

Gr. AvS

