Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46227 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932277AbeEHPYZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 May 2018 11:24:25 -0400
Date: Tue, 8 May 2018 15:24:18 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        keescook@chromium.org, josh@joshtriplett.org, teg@jklm.no,
        wagi@monom.org, hdegoede@redhat.com, andresx7@gmail.com,
        zohar@linux.vnet.ibm.com, kubakici@wp.pl, shuah@kernel.org,
        mfuzzey@parkeon.com, dhowells@redhat.com, pali.rohar@gmail.com,
        tiwai@suse.de, kvalo@codeaurora.org, arend.vanspriel@broadcom.com,
        zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org,
        broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org,
        torvalds@linux-foundation.org, Abhay_Salunke@dell.com,
        bjorn.andersson@linaro.org, jewalt@lgsinnovations.com,
        oneukum@suse.com, cantabile.desu@gmail.com, ast@fb.com,
        hare@suse.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com,
        khc@pm.waw.pl, davem@davemloft.net, maco@android.com,
        arve@android.com, tkjos@android.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v5 0/6] firmware_loader: cleanups for v4.18
Message-ID: <20180508152418.GB27853@wotan.suse.de> (sfid-20180508_172429_761593_5486A64B)
References: <20180504174356.13227-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180504174356.13227-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 04, 2018 at 10:43:49AM -0700, Luis R. Rodriguez wrote:
> Greg,
> 
> I've reviewed the pending patches for the firmware_laoder and as for
> v4.18, the following 3 patches from Andres have been iterated enough
> that they're ready after I made some final minor changes, mostly just
> style fixes and re-arrangements in terms of order. The new API he was
> suggesting to add requires just a bit more review.

We're done with review of the new API for the sync no warn call,
so I'll just re-issue another patch series with those patches
in a new series.

Coming right up.

  Luis
