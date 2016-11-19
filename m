Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33412 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751085AbcKSBzD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 20:55:03 -0500
Received: by mail-pf0-f196.google.com with SMTP id 144so14455816pfv.0
        for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2016 17:55:03 -0800 (PST)
Date: Sat, 19 Nov 2016 11:46:49 +1000
From: Barry Day <briselec@gmail.com>
To: Jes.Sorensen@redhat.com
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        Larry.Finger@lwfinger.net
Subject: Re: [PATCH 0/7] rtl8xxxu: Pending patches
Message-ID: <20161119014648.GA7140@testbox> (sfid-20161119_025507_357656_D263F92A)
References: <1479505468-29383-1-git-send-email-Jes.Sorensen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1479505468-29383-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 18, 2016 at 04:44:21PM -0500, Jes.Sorensen@redhat.com wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> Kalle,
> 
> Please find attached a number of patches for the rtl8xxxu
> driver.
> 
> The issues reported with wpa_supplicant on 8723bu still needs further
> investigation.
> 

The patch I posted that you want tested more will also fix the wpa_supplicant
issue.
Currently I'm looking at why the tx rate is not what it should be. I feel
fixing that first will be beneficial for fixing any other issues.

The recent merge has made my local branch of rtl8xxxu-devel 14 commits ahead.
Do I need to do a reset and submit a new patch for the DWA-131 dongle?

Barry
