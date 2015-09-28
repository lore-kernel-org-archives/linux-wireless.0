Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34682 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297AbbI1L1w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2015 07:27:52 -0400
Date: Mon, 28 Sep 2015 16:57:43 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Mateusz Kulikowski <mateusz.kulikowski@gmail.com>
Cc: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
	devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: rtl8723au: Fix resource leak
Message-ID: <20150928112743.GC10335@sudip-pc> (sfid-20150928_132811_794047_A3026E81)
References: <1443383299-2634-1-git-send-email-mateusz.kulikowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1443383299-2634-1-git-send-email-mateusz.kulikowski@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 27, 2015 at 09:48:19PM +0200, Mateusz Kulikowski wrote:
> Firmware was not released properly if kmemdup fails.
> 
> Addresses-Coverity-Id: 1269118
> Signed-off-by: Mateusz Kulikowski <mateusz.kulikowski@gmail.com>
> ---
Not seen your v2 while replying to your v1. Sorry for the noise.

regards
sudip
