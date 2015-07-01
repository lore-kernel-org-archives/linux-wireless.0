Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34183 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbbGAHMd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2015 03:12:33 -0400
Received: by pabvl15 with SMTP id vl15so18573380pab.1
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jul 2015 00:12:33 -0700 (PDT)
Date: Wed, 1 Jul 2015 12:42:24 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Michel von Czettritz <michel.von.czettritz@gmail.com>
Cc: gregkh@linux.com, devel@driverdev.osuosl.org,
	Jes.Sorensen@redhat.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net
Subject: Re: [PATCH 3/3] staging: rtl8723au: function no longer discards
 return value
Message-ID: <20150701071224.GC2411@sudip-PC> (sfid-20150701_091236_668121_183589EF)
References: <cover.1435700714.git.michel.von.czettritz@gmail.com>
 <f1f04f73db3d925d4a790a07fc56154ba98871fc.1435700714.git.michel.von.czettritz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f1f04f73db3d925d4a790a07fc56154ba98871fc.1435700714.git.michel.von.czettritz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 30, 2015 at 11:54:59PM +0200, Michel von Czettritz wrote:
> The return value of FillH2CCmd in rtl8723a_set_rssi_cmd and
> rtl8723a_set_raid_cmd is never checked. Both functions always return
> _SUCCESS.
> 
> Both functions now return the return value of FillH2CCmd.
If they are never checked then why do we need to return some value?
why not make them void?

regards
sudip
