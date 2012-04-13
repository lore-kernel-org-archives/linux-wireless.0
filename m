Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38169 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab2DMSC3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Apr 2012 14:02:29 -0400
Date: Fri, 13 Apr 2012 13:57:17 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/9] brcm80211: minor bug fixes for broadcom driver
Message-ID: <20120413175717.GD2616@tuxdriver.com> (sfid-20120413_200234_524989_60907A19)
References: <1334137971-3972-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1334137971-3972-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 11, 2012 at 11:52:42AM +0200, Arend van Spriel wrote:
> The series contains a number of patches to resolve some issues found
> in our brcmfmac regression testing. The brcmsmac changes are adressing
> a problem reported by several people within the community. Last patch
> in this series has been marked for stable tree.
> 
> This series is based on wireless-next repository and depends on the
> following patch message:
> 
> Message-ID: <1334098954-7556-2-git-send-email-jim.cromie@gmail.com>

In general, when mixing fixes and features/updates into a single
series then the fixes should come at the beginning of the series.
This helps to avoid dependencies on non-fix patches.

I'll try to apply patch 9 to the wireless tree, and if that works I
won't complain about it... :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
