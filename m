Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:43876
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbXKPKbm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 05:31:42 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] ssb: Fix compilation errors in ssb
Date: Fri, 16 Nov 2007 11:30:46 +0100
Cc: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <473d3d37.IWXGkSribrkSiHBl%Larry.Finger@lwfinger.net>
In-Reply-To: <473d3d37.IWXGkSribrkSiHBl%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711161130.46770.mb@bu3sch.de> (sfid-20071116_103146_138816_F322239C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 16 November 2007 07:48:23 Larry Finger wrote:
> Recent changes in ssb sprom handling break compilation. These two patches
> fix the problem.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> John,
> 
> These two changes should be applied to the everything branch of wireless-2.6
> ASAP. Sorry about the mixup - I have no idea what happened.

are your sprom r4 changes already applied? I didn't test that in the b44, yet.

-- 
Greetings Michael.
