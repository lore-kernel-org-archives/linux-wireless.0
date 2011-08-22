Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:50715 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756809Ab1HVLLv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 07:11:51 -0400
Received: by mail-bw0-f49.google.com with SMTP id 17so4358411bke.8
        for <linux-wireless@vger.kernel.org>; Mon, 22 Aug 2011 04:11:49 -0700 (PDT)
Subject: Re: [PATCH v2 00/40] wl12xx: move to wl12xx-fw-3
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1313317059-16567-1-git-send-email-eliad@wizery.com>
References: <1313317059-16567-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Aug 2011 14:11:46 +0300
Message-ID: <1314011506.2296.56.camel@cumari> (sfid-20110822_131154_562150_A77BD481)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-08-14 at 13:16 +0300, Eliad Peller wrote: 
> The new wl12xx fw (ver 7.3.0.0.75) had some major api changes.
> The main change was the addition of multi-role concept, which
> will later allow using multiple vifs concurrently.
> 
> Consequently, this design change caused api changes for most
> of the api commands, as a new role_id had to be added.
> 
> This patchset migrates the fw to use the new fw api (a new
> fw filename is used, as there is no backward compatability
> with older firmwares).
> 
> Additional patchsets will follow, with further bugfixes
> and new features (e.g. p2p support).
> 
> v2: apply Luca's comments, rebase.

Applied and pushed the series, including v3 of patch 02/40 and 23/40.

Thanks a lot for all the work!

-- 
Cheers,
Luca.

