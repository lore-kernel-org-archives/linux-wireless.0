Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:52748 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758948AbYCEJs5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 04:48:57 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1541912wah.23
        for <linux-wireless@vger.kernel.org>; Wed, 05 Mar 2008 01:48:56 -0800 (PST)
Date: Wed, 5 Mar 2008 18:48:59 +0900
From: Joonwoo Park <joonwpark81@gmail.com>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix races between siwessid and siwencode
Message-ID: <20080305094859.GA10077@ehus.geninetworks.com> (sfid-20080305_094926_270555_64B09F09)
References: <1204710009-10040-1-git-send-email-joonwpark81@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1204710009-10040-1-git-send-email-joonwpark81@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 05, 2008 at 06:40:09PM +0900, Joonwoo Park wrote:
> resolve: http://bughost.org/bugzilla/show_bug.cgi?id=1522
> 
> The function ieee80211_ioctl_siwencode shouldn't be called if
> authentication process is not completed.
> This patch makes the ieee80211_ioctl_siwessid to wait for authentication
> is completed.
> 
> Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>

Helge,

Can you please try this patch?
I believe this patch helps your problem.

Thanks,
Joonwoo
