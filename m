Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39757 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbbDXKXO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2015 06:23:14 -0400
Message-ID: <1429870991.1852.25.camel@sipsolutions.net> (sfid-20150424_122328_558805_702B0159)
Subject: Re: [PATCH v2] cfg80211: allow the plink state blocking for user
 managed mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 24 Apr 2015 12:23:11 +0200
In-Reply-To: <1429291802-14168-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20150417_193022_576150_EC3CD2B9)
References: <1429291802-14168-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20150417_193022_576150_EC3CD2B9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-04-18 at 01:30 +0800, Chun-Yeow Yeoh wrote:
> wpa_supplicant or authsae handles the mesh peering in user
> space, but the plink state is still managed in kernel space.
> Currently, there is no implementation by wpa_supplicant or
> authsae to block the plink state after it is set to ESTAB.
> 
> By applying this patch, we can use the "iw mesh0 station set
> <MAC address> plink_action block" to block the peer mesh STA.
> This is useful for experimenting purposes.

Applied.

johannes

