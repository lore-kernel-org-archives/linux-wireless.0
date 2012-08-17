Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:58908 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752374Ab2HQMzy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2012 08:55:54 -0400
Date: Fri, 17 Aug 2012 08:55:47 -0400
From: marco <marco@tampabay.rr.com>
To: "Chen, Stephen" <scchen@qca.qualcomm.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: carl9170: Unintentional transmission in monitor mode?
Message-ID: <20120817125547.GD7823@192.168.1.10> (sfid-20120817_145558_011528_2EF45A1E)
References: <20120809165434.GA13409@192.168.1.10>
 <201208092143.28506.chunkeey@googlemail.com>
 <1345144855.4665.3.camel@jlt3.sipsolutions.net>
 <201208162134.32152.chunkeey@googlemail.com>
 <124AAE9739743843BE54ED9463A8330D012EFF15@NASANEXD02D.na.qualcomm.com>
 <20120817023016.GA7823@192.168.1.10>
 <124AAE9739743843BE54ED9463A8330D012F052D@NASANEXD02D.na.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <124AAE9739743843BE54ED9463A8330D012F052D@NASANEXD02D.na.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No, I don't believe so.  I didn't do much testing in managed mode but when I
did try it, it didn't exhibit the issue.

Marco

On Fri, Aug 17, 2012 at 02:59:40AM +0000, Chen, Stephen wrote:
> To be honest, I have no idea why the device was transmitting invalid frame.
> If the device is not in monitor mode, will it still transmit invalid frame in your setup?
> 
> 
> Thank you.
> Stephen
> 
> 
