Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36167 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab3FXN41 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 09:56:27 -0400
Message-ID: <1372082182.8439.5.camel@jlt4.sipsolutions.net> (sfid-20130624_155634_202976_B36397CA)
Subject: Re: [PATCH-WN 1/3] wireless: Make sure __cfg80211_connect_result
 always puts bss.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Mon, 24 Jun 2013 15:56:22 +0200
In-Reply-To: <1371675987-28732-1-git-send-email-greearb@candelatech.com> (sfid-20130619_230648_480145_A5400A87)
References: <1371675987-28732-1-git-send-email-greearb@candelatech.com>
	 (sfid-20130619_230648_480145_A5400A87)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-06-19 at 14:06 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Otherwise, we can leak a bss reference.

Applied all 3, still trying to make up my mind about the debugfs one
patch :)

johannes

