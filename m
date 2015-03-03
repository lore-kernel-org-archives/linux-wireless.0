Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54631 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508AbbCCIsP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 03:48:15 -0500
Message-ID: <1425372493.2450.10.camel@sipsolutions.net> (sfid-20150303_094818_798607_3160A6BB)
Subject: Re: [PATCH iw] phy: Allow set netns by fd
From: Johannes Berg <johannes@sipsolutions.net>
To: Vadim Kochan <vadim4j@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 03 Mar 2015 09:48:13 +0100
In-Reply-To: <1423899192-4315-1-git-send-email-vadim4j@gmail.com> (sfid-20150214_084418_653591_0E438BB1)
References: <1423899192-4315-1-git-send-email-vadim4j@gmail.com>
	 (sfid-20150214_084418_653591_0E438BB1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-02-14 at 09:33 +0200, Vadim Kochan wrote:
> From: Vadim Kochan <vadim4j@gmail.com>
> 
> Added possibility to change network namespace
> for phy device by network namespace name from
> /var/run/netns or by absolute file path:
> 
> iw phy XXX set netns name <nsname>
> 
> iw tries to open fd of given nsname from /var/run/netns
> or by absoute path if nsname contains "/".

Applied, thanks.

johannes

