Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.11]:43658 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750798AbeCMEn0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 00:43:26 -0400
Date: Mon, 12 Mar 2018 21:43:14 -0700
From: Jakub Kicinski <kubakici@wp.pl>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        cantabile.desu@gmail.com, linux-wireless@vger.kernel.org,
        keescook@chromium.org, shuah@kernel.org, mfuzzey@parkeon.com,
        zohar@linux.vnet.ibm.com, dhowells@redhat.com,
        pali.rohar@gmail.com, tiwai@suse.de, arend.vanspriel@broadcom.com,
        zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org,
        broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org,
        torvalds@linux-foundation.org, Abhay_Salunke@dell.com,
        bjorn.andersson@linaro.org, jewalt@lgsinnovations.com,
        oneukum@suse.com, ast@fb.com, andresx7@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 20/20] mt7601u: use request_firmware_cache() to
 address cache on reboot
Message-ID: <20180312214314.481b142a@cakuba.netronome.com> (sfid-20180313_054331_399458_469B427F)
In-Reply-To: <20180310141501.2214-21-mcgrof@kernel.org>
References: <20180310141501.2214-1-mcgrof@kernel.org>
        <20180310141501.2214-21-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 10 Mar 2018 06:15:01 -0800, Luis R. Rodriguez wrote:
> request_firmware_cache() will ensure the firmware is available on resume
> from suspend if on reboot the device retains the firmware.
> 
> This optimization is in place given otherwise on reboot we have to
> reload the firmware, the opmization saves us about max 1s, minimum 10ms.
> 
> Cantabile has reported back this fixes his woes with both suspend and
> hibernation.
> 
> Reported-by: Cantabile <cantabile.desu@gmail.com>
> Tested-by: Cantabile <cantabile.desu@gmail.com>
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>

FWIW:

Acked-by: Jakub Kicinski <kubakici@wp.pl>

Thanks Luis!!
