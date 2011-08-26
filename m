Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4949 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403Ab1HZRcu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 13:32:50 -0400
Date: Fri, 26 Aug 2011 10:31:59 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "Arend Van Spriel" <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Henry Ptasinski" <henryp@broadcom.com>, hharte@broadcom.com
Subject: Re: [PATCH 00/14] staging: brcm80211: brcmfmac driver cleanup
Message-ID: <20110826173159.GA4888@broadcom.com> (sfid-20110826_193255_053197_3ECD000B)
References: <1313156101-16817-1-git-send-email-arend@broadcom.com>
 <CACna6rztueomzzas=hQjfj6htD=SHFhrtFPSqbviqVDwaihJ9w@mail.gmail.com>
 <4E4555AD.7040809@broadcom.com>
 <CACna6rx_d4btykdK7AMwFxeFMs_MxjHEHvR6coxaZkfqkQVafA@mail.gmail.com>
 <CACna6rzJWHP+EPy6bwQkLZnjxsL6TKfYnQ71Nq8myOjmeBPODg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CACna6rzJWHP+EPy6bwQkLZnjxsL6TKfYnQ71Nq8myOjmeBPODg@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 26, 2011 at 02:20:43AM -0700, Rafał Miłecki wrote:
> W dniu 12 sierpnia 2011 22:04 użytkownik Rafał Miłecki
> <zajec5@gmail.com> napisał:
> > W dniu 12 sierpnia 2011 18:32 użytkownik Arend van Spriel
> > <arend@broadcom.com> napisał:
> >> On 08/12/2011 04:02 PM, Rafał Miłecki wrote:
> >>>
> >>> 2011/8/12 Arend van Spriel<arend@broadcom.com>:
> >>>>
> >>>> Several cleanup patches to reduce code for the brcmfmac driver and
> >>>> get rid of a remaining checkpatch warning. The driver sources should
> >>>> be clear from checkpatch issue now.
> >>>>
> >>>> This series applies to staging-next and depends on the following patch
> >>>> set:
> >>>
> >>> Are you testing patches on some hardware? Or just compile-testing?
> >>>
> >>> I believe this driver is meant to support BCM4329, which is not PCI(e)
> >>> board. What adapter do you use?
> >>>
> >>> I've heard about Arasan adapter. Have you tried it? Is that something
> >>> reachable from arasan.com?
> >>
> >> Our brcm80211 source tree under drivers/staging contain two drivers. The
> >> brcmsmac driver currently supporting the PCI(e) cards with bcm43224,
> >> bcm43225, and bcm4313 chips and the brcmfmac driver currently supporting the
> >> SDIO card with bcm4329 chip. brcmsmac is a mac80211 driver and brcmfmac is a
> >> cfg80211 driver.
> >>
> >> We indeed use the Arasan adapter and both drivers are running in nightly
> >> test cycle testing our common internal repository. So the drivers are
> >> functionally tested on the x86 platforms (32 and 64 bit). Also looking at
> >> sparc64 and powerpc64 but not in a nightly cycle.
> >
> > Is there a chance you can donate me with such a adapter and card?
> 
> Ping?

Sorry, I meant to respond to this earlier.  The Arasan adapters are in very
short supply here, and honestly they have enough issues that we're looking for
better options.  A possibly better approach would be a device with a BCM4329 on
the motherboard (e.g. table, phone, etc) that can run a relatively stock linux
kernel.  However, I don't know of a specific platform at the moment to
recommend.

A second choice would be something with a decent sdio controller built-in.
Some older laptops worked ok (e.g. Dell E4100), but they're more and more
diffucult to find.

- Henry


