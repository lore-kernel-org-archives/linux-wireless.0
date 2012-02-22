Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49322 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab2BVTQw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 14:16:52 -0500
Date: Wed, 22 Feb 2012 14:14:25 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/15] brcm80211: resolve brcmsmac issues and brcmfmac
 usb support
Message-ID: <20120222191425.GB822@tuxdriver.com> (sfid-20120222_201655_292679_BB683564)
References: <1328818149-4826-1-git-send-email-arend@broadcom.com>
 <4F4521EB.4090709@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F4521EB.4090709@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 22, 2012 at 06:12:11PM +0100, Arend van Spriel wrote:
> On 02/09/2012 09:08 PM, Arend van Spriel wrote:
> >This patch series contains patches for a couple of issue in brcmsmac. The A-MPDU
> >endless retry fix is a long standing issue that exists in previous kernels. So
> >it should go to 3.3 kernel.
> >
> >For the brcmfmac driver support has been added for USB chipsets. Firmware has
> >been submitted for bcm43235, bcm43236, and bcm43238 chipsets.
> >
> 
> Hi John,
> 
> I send this patch series a while ago. I wanted to be sure whether
> they are scheduled to be taken in or is there some issue with it
> that we need to address, eg. indentation ;-) I looked in my email
> archive for community response and did not see any obvious show
> stopper there.
> 
> One patch in the series is same as I attached to redhat bug 787649
> (see [1]).
> 
> Regards,
> AvS
> 
> [1] https://bugzilla.redhat.com/show_bug.cgi?id=787649

I apologize to you and the other contributors.  I've been embroiled
in something elsewhere that has been occupying a lot of my time over
the past week or two.  I hope to be getting back to more regular
-next merging soon.

I appreciate your patience!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
