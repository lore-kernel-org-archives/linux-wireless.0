Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:47827 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab2KSVdW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 16:33:22 -0500
Date: Mon, 19 Nov 2012 15:33:17 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	Daniel Wagner <wagi@monom.org>
Subject: Re: [PATCH v2 00/22] brcmsmac: Tx rework and expanded debug/trace
 support
Message-ID: <20121119213317.GD20301@thinkpad-t410> (sfid-20121119_223325_214749_84328B5C)
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
 <50AA9A4C.3070500@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50AA9A4C.3070500@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 19, 2012 at 09:45:00PM +0100, Arend van Spriel wrote:
> On 11/15/2012 03:07 PM, Seth Forshee wrote:
> >Hi Arend,
> >
> >As promised, here's the updated patch series for brcmsmac to remove the
> >tx packet queue, add flow control, and add enhanced debug trace support.
> >I've broken up the tx rework into multiple patches as you requested.
> >Most notably I've split out the AMPDU session support into a separate
> >patch, which should make it easier to review that change. I've done
> >basic testing of each of the new commits to try and verify that no
> >obvious regressions are introduced by any of them.
> 
> I replied to the patches that were reworked. We skipped the already
> Acked-by patches in this review round.

Great, thanks! I'm hoping it's not to late to get these in for 3.8.

John: Arend had contacted me off-list last week noting a conflict with
wireless-testing. I resolved this and pushed it to the following branch
if you'd like to take the patches from there. It is lacking the
Reviewed-by tags that Arend supplied today, however.

 git://kernel.ubuntu.com/sforshee/linux.git brcms-tx-wireless-testing

> The patches have been in nightly testing on bcm43224 for a couple of
> days. It still occasionally does show the infamous warning in the
> .flush() callback. Can not have it all. I want to run the changes on
> bcm4313 as well.

Hopefully we can get this one taken care of soon, and the channel
suppression errors as well ;-)

Seth

