Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51187 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751790AbeCTReM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 13:34:12 -0400
Date: Tue, 20 Mar 2018 17:34:09 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, akpm@linux-foundation.org,
        cantabile.desu@gmail.com, kubakici@wp.pl,
        linux-wireless@vger.kernel.org, keescook@chromium.org,
        shuah@kernel.org, mfuzzey@parkeon.com, zohar@linux.vnet.ibm.com,
        dhowells@redhat.com, pali.rohar@gmail.com, tiwai@suse.de,
        arend.vanspriel@broadcom.com, zajec5@gmail.com, nbroeking@me.com,
        markivx@codeaurora.org, broonie@kernel.org,
        dmitry.torokhov@gmail.com, dwmw2@infradead.org,
        torvalds@linux-foundation.org, Abhay_Salunke@dell.com,
        bjorn.andersson@linaro.org, jewalt@lgsinnovations.com,
        oneukum@suse.com, ast@fb.com, andresx7@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 19/20] firmware: add request_firmware_cache() to help
 with cache on reboot
Message-ID: <20180320173409.GD4449@wotan.suse.de> (sfid-20180320_183439_530014_715FCC69)
References: <20180310141501.2214-1-mcgrof@kernel.org>
 <20180310141501.2214-20-mcgrof@kernel.org>
 <20180320083055.GA21640@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180320083055.GA21640@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 20, 2018 at 09:30:55AM +0100, Greg KH wrote:
> On Sat, Mar 10, 2018 at 06:15:00AM -0800, Luis R. Rodriguez wrote:
> > +EXPORT_SYMBOL_GPL(request_firmware_cache);
> 
> I know you are just following the existing naming scheme, but please
> let's not continue the problem here.  Can you prefix all of the firmware
> exported symbols with "firmware_", and then the verb.  So this would be
> "firmware_request_cache",

Sure.

>  and the older function would be
> "firmware_request_direct".

Sure, so you want to also rename the old exported symbols, and add a macro
or static inline to enable use of the older names?

> I've stopped here in the patch series, applying the others now, so feel
> free to rebase and resend what I've missed, and the minor fixups for the
> prior patches.

Sure thing.

   Luis
