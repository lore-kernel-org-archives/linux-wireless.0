Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3532 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251Ab1HZRzZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 13:55:25 -0400
Date: Fri, 26 Aug 2011 10:55:10 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Arend Van Spriel" <arend@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [PATCH v2] Move brcm80211 to mainline
Message-ID: <20110826175510.GG4888@broadcom.com> (sfid-20110826_195529_033786_96BC6FED)
References: <20110707002034.GA17885@broadcom.com>
 <20110824222801.GA5280@broadcom.com>
 <CACna6rwG6qNpaOu4QeOvs0L3LVETRt9w5=Ec-L2NJ5gXOAM=nw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CACna6rwG6qNpaOu4QeOvs0L3LVETRt9w5=Ec-L2NJ5gXOAM=nw@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 25, 2011 at 01:55:26PM -0700, Rafał Miłecki wrote:
> 2011/8/25 Henry Ptasinski <henryp@broadcom.com>:
> > With the latest series of cleanup patches merged in by Greg KH, I'd like to
> > once again propose moving brcm80211 out of staging and into mainline.
> 
> Henry: a simple question, please explain it to me, what brcmsmac does
> provide that b43 doesn't?

The brcmsmac driver supports the BCM4313, BCM43224, and BCM43225 chipsets with
full performance i.e. rate vs. range comparable to what's achived with these
chips running under other operating systems.

The underlying phy algorithms, especially the dynamic calibrations, have been
designed and tested, over the full range of chip operating temperatures, and
across fabrication process corners, to maximize the performance acheived in all
cases.

The driver is fully supported by Broadcom, and provides an API for addition of
phy support for newer chipsets that will help speed up the process of getting
support for those chipsets into the kernel.

- Henry


