Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:51182 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725964AbeIAL7F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Sep 2018 07:59:05 -0400
Date: Sat, 1 Sep 2018 09:47:58 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Sid Hayn <sidhayn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        lorenzo.bianconi@redhat.com, nbd@nbd.name,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v2 00/17] mt76 patches 2018-08-24 v2
Message-ID: <20180901074757.GB3719@redhat.com> (sfid-20180901_094804_391396_83D412C7)
References: <1535381791-14908-1-git-send-email-sgruszka@redhat.com>
 <CAM0KTbB5k54BvA2UOmoss-PuGtgHE_SGy2cG4n4ROxPH7kxYXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAM0KTbB5k54BvA2UOmoss-PuGtgHE_SGy2cG4n4ROxPH7kxYXA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 29, 2018 at 02:26:44AM +0000, Sid Hayn wrote:
> dhcpcd_prestartinterface: t2uh: No space left on device
> t2uh: waiting for carrier
> 
> the same happens with just ifconfig up:
> 
> SIOCSIFFLAGS: No space left on device

I think I found bug that could result in this. Please test
below patch:

https://github.com/sgruszka/wireless-drivers-next/commit/be446879afd6b0e315691e379a2aa4412f05884e.patch

Thanks
Stanislaw
