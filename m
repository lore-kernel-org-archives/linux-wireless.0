Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51428 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbbJMIb5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 04:31:57 -0400
Message-ID: <1444725115.1961.3.camel@sipsolutions.net> (sfid-20151013_103201_151792_025F02C5)
Subject: Re: [PATCH] mac80211: Fix hwflags debugfs file format
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni@qca.qualcomm.com>
Date: Tue, 13 Oct 2015 10:31:55 +0200
In-Reply-To: <1444312214-10669-1-git-send-email-mohammed@qti.qualcomm.com>
References: <1444312214-10669-1-git-send-email-mohammed@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-10-08 at 19:20 +0530, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> Commit 30686bf7f5b3 ("mac80211: convert HW flags to unsigned long
> bitmap") accidentally removed the newline delimiter from the hwflags
> debugfs file. Fix this by adding back the newline between the HW 
> flags.
> 
Applied, thanks.

johannes
