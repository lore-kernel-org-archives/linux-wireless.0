Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46674 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751105AbdKULhr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2017 06:37:47 -0500
Message-ID: <1511264260.4011.274.camel@coelho.fi> (sfid-20171121_123750_567867_8DEB15B3)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>, mcgrof@kernel.org
Cc: sedat.dilek@gmail.com, linux-wireless@vger.kernel.org,
        linuxwifi <linuxwifi@intel.com>
Date: Tue, 21 Nov 2017 13:37:40 +0200
In-Reply-To: <871skrdiaf.fsf@kamboji.qca.qualcomm.com>
References: <1511175768.4011.261.camel@coelho.fi>
         <CA+icZUVqhmH3dyMXkHKsHus5qyfMqQfcOctvHRDf4x=6+ndfPw@mail.gmail.com>
         <1511259055.4011.268.camel@coelho.fi>
         <871skrdiaf.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: pull-request: iwlwifi 2017-11-19
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-11-21 at 12:42 +0200, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > > [   10.630285] iwlwifi 0000:04:00.0: firmware: failed to load
> > > iwlwifi-8265-34.ucode (-2)
> > > [   10.630331] iwlwifi 0000:04:00.0: Direct firmware load for
> > > iwlwifi-8265-34.ucode failed with error -2
> > > [   10.630454] iwlwifi 0000:04:00.0: firmware: failed to load
> > > iwlwifi-8265-33.ucode (-2)
> > > [   10.630479] iwlwifi 0000:04:00.0: Direct firmware load for
> > > iwlwifi-8265-33.ucode failed with error -2
> > > [   10.630486] iwlwifi 0000:04:00.0: firmware: failed to load
> > > iwlwifi-8265-32.ucode (-2)
> > > [   10.630510] iwlwifi 0000:04:00.0: Direct firmware load for
> > > iwlwifi-8265-32.ucode failed with error -2
> > > [   10.636423] iwlwifi 0000:04:00.0: firmware: direct-loading
> > > firmware
> > > iwlwifi-8265-31.ucode
> > > [   10.637463] iwlwifi 0000:04:00.0: loaded firmware version
> > > 31.532993.0 op_mode iwlmvm
> > 
> > This is an unfortunate side-effect of the way firmwares are
> > loaded. 
> > There is currently no way to prevent these error messages by making
> > some files optional... But you can ignore them.  Or, even better,
> > upgrade your firmware to the latest version the driver supports. :)
> 
> Or even better that we improve request_firmware()&co to make it
> possible
> not to print an error message :)

The last time we discussed this, Luis was working on changes to the
firmware subsystem APIs, but I stopped following and have no idea what
happened with those patches...

--
Cheers,
Luca.
