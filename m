Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46734 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758074Ab3JKN1h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 09:27:37 -0400
Message-ID: <1381498047.14293.15.camel@jlt4.sipsolutions.net> (sfid-20131011_152744_993455_612B807B)
Subject: Re: [PATCH] cfg80211: Pass station supported channel and oper class
 info to kernel
From: Johannes Berg <johannes@sipsolutions.net>
To: Sunil Dutt <c_duttus@qti.qualcomm.com>
Cc: j@w1.fi, linux-wireless@vger.kernel.org
Date: Fri, 11 Oct 2013 15:27:27 +0200
In-Reply-To: <1381331721-12324-1-git-send-email-c_duttus@qti.qualcomm.com>
References: <1381331721-12324-1-git-send-email-c_duttus@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-10-09 at 20:45 +0530, Sunil Dutt wrote:
> The information of the peer's supported channels and supported operating
> classes are required for the driver to perform TDLS off channel
> operations. This commit enhances the function nl80211_(new)set_station
> to pass this information of the peer to the driver.

Applied, but I made it return an error for %2 case. Please adjust your
wpa_s changes accordingly.

johannes

