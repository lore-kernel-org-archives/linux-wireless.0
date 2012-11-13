Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4325 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413Ab2KMVwl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 16:52:41 -0500
Message-ID: <50A2C119.3050503@broadcom.com> (sfid-20121113_225245_962047_1A0C9870)
Date: Tue, 13 Nov 2012 22:52:25 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Randy Dunlap" <rdunlap@infradead.org>
cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Stephen Rothwell" <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH -next] wireless: brcmfmac: fix printk format warning
References: <20121101163622.129b59967d2ee76e6946874a@canb.auug.org.au>
 <5092B4BE.4080803@infradead.org> <5092B900.2090801@broadcom.com> (
 sfid-20121101_190234_358746_9918835B)
 <1351798279.17469.0.camel@jlt4.sipsolutions.net>
 <50A26D66.4060603@infradead.org>
In-Reply-To: <50A26D66.4060603@infradead.org>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/13/2012 04:55 PM, Randy Dunlap wrote:
> On 11/01/2012 12:31 PM, Johannes Berg wrote:
>
>> On Thu, 2012-11-01 at 19:01 +0100, Arend van Spriel wrote:
>>> On 11/01/2012 06:43 PM, Randy Dunlap wrote:
>>>> From: Randy Dunlap <rdunlap@infradead.org>
>>>>
>>>> Fix printk format warning for ssid_len, which is a size_t:
>>>>
>>>> drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:3941:2: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'
>>>>
>>>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>>>> Cc:	brcm80211-dev-list@broadcom.com
>>>
>>>
>>> We actually have a patch ready for that with credit to people who
>>> reported it. We can add you to that list ;-)
>>
>> Which you've been sitting on for WAY too long already :)
>
> ping Arend.
> Please have your patch included in linux-next builds.  thanks.
>

It has been posted to John on November 6th. The wireless summit in 
Barcelona probably gave some delay.

It is on the wireless list named "[PATCH 19/24] brcmfmac: fix build 
regression".

Gr. AvS

