Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1588 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab1HLQdD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 12:33:03 -0400
Message-ID: <4E4555AD.7040809@broadcom.com> (sfid-20110812_183308_461089_C59BCA66)
Date: Fri, 12 Aug 2011 18:32:45 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/14] staging: brcm80211: brcmfmac driver cleanup
References: <1313156101-16817-1-git-send-email-arend@broadcom.com>
 <CACna6rztueomzzas=hQjfj6htD=SHFhrtFPSqbviqVDwaihJ9w@mail.gmail.com>
In-Reply-To: <CACna6rztueomzzas=hQjfj6htD=SHFhrtFPSqbviqVDwaihJ9w@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/12/2011 04:02 PM, Rafał Miłecki wrote:
> 2011/8/12 Arend van Spriel<arend@broadcom.com>:
>> Several cleanup patches to reduce code for the brcmfmac driver and
>> get rid of a remaining checkpatch warning. The driver sources should
>> be clear from checkpatch issue now.
>>
>> This series applies to staging-next and depends on the following patch set:
> Are you testing patches on some hardware? Or just compile-testing?
>
> I believe this driver is meant to support BCM4329, which is not PCI(e)
> board. What adapter do you use?
>
> I've heard about Arasan adapter. Have you tried it? Is that something
> reachable from arasan.com?

Our brcm80211 source tree under drivers/staging contain two drivers. The 
brcmsmac driver currently supporting the PCI(e) cards with bcm43224, 
bcm43225, and bcm4313 chips and the brcmfmac driver currently supporting 
the SDIO card with bcm4329 chip. brcmsmac is a mac80211 driver and 
brcmfmac is a cfg80211 driver.

We indeed use the Arasan adapter and both drivers are running in nightly 
test cycle testing our common internal repository. So the drivers are 
functionally tested on the x86 platforms (32 and 64 bit). Also looking 
at sparc64 and powerpc64 but not in a nightly cycle.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


