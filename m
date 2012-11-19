Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3570 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab2KSUpS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 15:45:18 -0500
Message-ID: <50AA9A4C.3070500@broadcom.com> (sfid-20121119_214522_021807_96D6D180)
Date: Mon, 19 Nov 2012 21:45:00 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	"Daniel Wagner" <wagi@monom.org>
Subject: Re: [PATCH v2 00/22] brcmsmac: Tx rework and expanded
 debug/trace support
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/15/2012 03:07 PM, Seth Forshee wrote:
> Hi Arend,
>
> As promised, here's the updated patch series for brcmsmac to remove the
> tx packet queue, add flow control, and add enhanced debug trace support.
> I've broken up the tx rework into multiple patches as you requested.
> Most notably I've split out the AMPDU session support into a separate
> patch, which should make it easier to review that change. I've done
> basic testing of each of the new commits to try and verify that no
> obvious regressions are introduced by any of them.

I replied to the patches that were reworked. We skipped the already 
Acked-by patches in this review round.

The patches have been in nightly testing on bcm43224 for a couple of 
days. It still occasionally does show the infamous warning in the 
.flush() callback. Can not have it all. I want to run the changes on 
bcm4313 as well.

Gr. AvS


