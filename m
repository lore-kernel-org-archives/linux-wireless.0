Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262Ab2K3Kf5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 05:35:57 -0500
Date: Fri, 30 Nov 2012 11:35:49 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: johannes@sipsolutions.net,
	linux-wireless <linux-wireless@vger.kernel.org>,
	maheshp@posedge.com, chaitanyatk@posedge.com
Subject: Re: [PATCH] iwl4965:Fixing Broken Monitor Mode Functionality
Message-ID: <20121130103549.GA26790@redhat.com> (sfid-20121130_113608_659011_2AA408B3)
References: <CABPxzYL=MBQ3uZR=EmcNAa-9iELPKRWtwZNBnxpFdk7z5XpPKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CABPxzYL=MBQ3uZR=EmcNAa-9iELPKRWtwZNBnxpFdk7z5XpPKw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 30, 2012 at 02:59:12PM +0530, Krishna Chaitanya wrote:
> From the patch  "90b9e446fbb64630c72cab48c007d7081aec2533: mac80211:
> support radiotap vendor namespace RX data"
> the monitor mode functionality in iwl4965 stopped working, because of
> below issues
> 
> 1) The driver doesnt fill the newly added fields in the ieee80211_rx_status
> and also doesn't do a memset leading to junk values.

Already fixed by Johannes:
https://patchwork.kernel.org/patch/1788371/

Stanislaw

