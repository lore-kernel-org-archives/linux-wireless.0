Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:57277 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbaATCWd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jan 2014 21:22:33 -0500
Date: Mon, 20 Jan 2014 13:22:23 +1100
From: James Cameron <quozl@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: Ben Hutchings <ben@decadent.org.uk>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
	Frank Huang <frankh@marvell.com>
Subject: Re: linux-firmware: pull-request Marvell mwifiex-firmware 2014-01-09
Message-ID: <20140120022223.GI17658@us.netrek.org> (sfid-20140120_032259_681724_15558974)
References: <1389325691-21371-1-git-send-email-bzhao@marvell.com>
 <1390174797.3651.7.camel@deadeye.wl.decadent.org.uk>
 <477F20668A386D41ADCC57781B1F70430F53691E15@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <477F20668A386D41ADCC57781B1F70430F53691E15@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 19, 2014 at 06:10:03PM -0800, Bing Zhao wrote:
> The 2nd (69 or 68) and 3rd (11 or 29) numbers in the version string
> do not necessarily mean the version increasing or decreasing. Only
> when first 3 numbers are fixed, a smaller 4th number will mean that
> the version is rolling backward.

Ah, light dawns.  I've been dealing with these version numbers for
years now, for 8388, 8686 and 8787, and I didn't know that.  Is this
documented anywhere else?  Have the 2nd and 3rd numbers any meaning or
are they random?

-- 
James Cameron
http://quozl.linux.org.au/
