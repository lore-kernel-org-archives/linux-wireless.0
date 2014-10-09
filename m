Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58325 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbaJIOVQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 10:21:16 -0400
Message-ID: <1412864474.1828.51.camel@jlt4.sipsolutions.net> (sfid-20141009_162119_103163_68F22CA7)
Subject: Re: [PATCHv3 2/2] iw: add auto parameter to set distance command
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 09 Oct 2014 16:21:14 +0200
In-Reply-To: <1410111140-4340-3-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140907_193225_979854_E1C1E499)
References: <1410111140-4340-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 <1410111140-4340-3-git-send-email-lorenzo.bianconi83@gmail.com>
	 (sfid-20140907_193225_979854_E1C1E499)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-09-07 at 19:32 +0200, Lorenzo Bianconi wrote:
> Add auto parameter to set distance command in order to enable ACK timeout
> estimation algorithm (dynack). Dynack is automatically disabled setting valid
> value for coverage class. Currently dynack is supported just by ath9k
> 
> This patch is based on "configure dynack through mac80211/cfg80211 stack"
> patchset sent on linux-wireless

Applied.

>  nl80211.h | 12 ++++++++++++

Somehow you also changed nl80211.h here - you shouldn't do that at all
really :) I will deal with the updates of that file for iw.

johannes

