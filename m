Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60801 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab1IUUIe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 16:08:34 -0400
Received: by gxk6 with SMTP id 6so1463537gxk.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2011 13:08:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316516031-24049-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1316516031-24049-1-git-send-email-rmanohar@qca.qualcomm.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Wed, 21 Sep 2011 13:08:12 -0700
Message-ID: <CAB=NE6UNVYv4oo=R47WU6CnVpd+OSbvwAcQ2sszz=7xycsccBA@mail.gmail.com> (sfid-20110921_220839_432076_4161D3D3)
Subject: Re: [PATCH] ath9k_hw: Fix Rx DMA stuck for AR9003 chips
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 20, 2011 at 3:53 AM, Rajkumar Manoharan
<rmanohar@qca.qualcomm.com> wrote:
> During the endurance testing, rx frames are not getting DMAd from
> MAC whereas pcu rx frame counters are getting updated properly.
> As per systems team input updated the initval to fix rx dma stuck
> issue.
>
> Cc: stable@kernel.org
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

So does this fix the counter mismatch? Please also send me a
respective patch for initvals-tool:

git://github.com/mcgrof/initvals-tool.git

Can you confirm the checksums check out and match the internal files afterwards?

  Luis
