Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1643 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280Ab1IVIxV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 04:53:21 -0400
From: "Arend Van Spriel" <arend@broadcom.com>
To: =?iso-8859-2?Q?Michael_B=FCsch?= <m@bues.ch>,
	"Brett Rudley" <brudley@broadcom.com>
cc: =?iso-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
	"Greg KH" <greg@kroah.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"jonas.gorski@gmail.com" <jonas.gorski@gmail.com>
Date: Thu, 22 Sep 2011 01:53:11 -0700
Subject: RE: [PATCH 00/20] staging: brcm80211: 7th reaction for mainline
 patch #2
Message-ID: <400C43189542CE41BC0A5B252FC90136BC0CC8ABB9@SJEXCHCCR02.corp.ad.broadcom.com> (sfid-20110922_105326_400661_F069DB07)
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
 <20110920130338.GA9885@kroah.com> <20110920132203.GB7800@tuxdriver.com>
 <20110920140020.GA11386@kroah.com>
 <7A94256FD72B884D9E7C55586C3CBCEE195814DD85@SJEXCHCCR01.corp.ad.broadcom.com>
 <CACna6rzSiH3g9y6F6t8JT4abCy0pO9v+ATCBeYmNdmNdo5BaDQ@mail.gmail.com>
 <7A94256FD72B884D9E7C55586C3CBCEE195814DE4F@SJEXCHCCR01.corp.ad.broadcom.com>
 <20110922003523.0bf6a460@milhouse>
 <7A94256FD72B884D9E7C55586C3CBCEE195814DE92@SJEXCHCCR01.corp.ad.broadcom.com>
 <20110922012851.2f3b7801@milhouse>
In-Reply-To: <20110922012851.2f3b7801@milhouse>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=iso-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> owner@vger.kernel.org] On Behalf Of Michael Büsch
> Sent: donderdag 22 september 2011 1:29
> To: Brett Rudley
> Cc: Rafa³ Mi³ecki; Greg KH; John W. Linville; Franky (Zhenhui) Lin;
> gregkh@suse.de; devel@linuxdriverproject.org; linux-
> wireless@vger.kernel.org
> Subject: Re: [PATCH 00/20] staging: brcm80211: 7th reaction for
> mainline patch #2
> 
> On Wed, 21 Sep 2011 16:15:10 -0700
> "Brett Rudley" <brudley@broadcom.com> wrote:
> 
> > We did however initially propose (and implement) a dividing line of
> ssb chips for b43 and AXI based chips for brcmsmac but b43 team chose
> to ignore/reject that.
> 
> Well, what about embedded, for instance?

The brcmsmac driver has been tested on a MIPS platform by Jonas Gorski
although only in STA mode (on a bcm63xx). Not having AP mode has been
explained in other emails.

Also we fully intend to transition to BCMA but that would also be new
feature added. Having AP mode and BCMA would enable you guys for using
it in the embedded targets, right?

> > I'm not totally opposed to that idea but it does not solve the
> primary issue of conflicting b43 and brcmsmac modules.
> 
> I'm not convinced that this is an issue at all and I'm not convinced
> that it has to be resolved.
> At least not now.
> 

It never hurts to look ahead. Both drivers have their use in the linux
tree and we should align which driver is doing what. Apparently we should
have yelled really hard when b43 was adding bcma support, because then
it snatched the chipsets we support as well. You learn your lessons the
hard way in Linux land, or so it seems ;-)

Gr. AvS

