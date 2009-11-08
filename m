Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:58456 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbZKHSOp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 13:14:45 -0500
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [git patches] rt2800 drivers updates
Date: Sun, 8 Nov 2009 19:13:04 +0100
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	linux-kernel@vger.kernel.org
References: <200911081433.32005.bzolnier@gmail.com> <4AF6DE9A.1030204@gmail.com> <200911081622.52151.bzolnier@gmail.com>
In-Reply-To: <200911081622.52151.bzolnier@gmail.com>
MIME-Version: 1.0
Message-Id: <200911081913.04994.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 08 November 2009 16:22:52 Bartlomiej Zolnierkiewicz wrote:
> On Sunday 08 November 2009 16:07:06 Gertjan van Wingerde wrote:
> 
> > Ehm, nothing seems to be available in the git repository you pointed to. Did you push it there?
> 
> Yes but kernel.org mirroring seems to be snail-slow today..

The current branch is now rt2800-v3.1, changes:
- fixed build problem reported by Hauke Mehrtens
- added "rt2x00: Remove deprecated ieee80211_rx_status->qual usage" patch
  from Ivo and "rt2x00: Update copyright statements." from you

It may take some time to get it to kernel.org mirrors though..

-- 
Bartlomiej Zolnierkiewicz
