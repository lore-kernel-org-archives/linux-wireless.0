Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45972 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756730AbdKPJtO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Nov 2017 04:49:14 -0500
Message-ID: <1510825750.4011.179.camel@coelho.fi> (sfid-20171116_104920_628293_45534B82)
From: Luca Coelho <luca@coelho.fi>
To: Chris Chiu <chiu@endlessm.com>
Cc: johannes.berg@intel.com, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org,
        Linux Upstreaming Team <linux@endlessm.com>
Date: Thu, 16 Nov 2017 11:49:10 +0200
In-Reply-To: <CAB4CAwcwVEyFX=7KJcAT9eXQoof_M+U+tB+FRQCnoP5WgK-MrQ@mail.gmail.com>
References: <CAB4CAwdO0dKAinnPk+ihJyDgOJ1z=2D=+pLMrObJYH+QiaDRqA@mail.gmail.com>
         <1509434718.4492.195.camel@coelho.fi>
         <CAB4CAwc43h5g+zLYd3hv=STELNGH+NEeQOMAXd-Gm0xj+TNuyA@mail.gmail.com>
         <1509952948.4492.360.camel@coelho.fi>
         <CAB4CAwc0G0j1zb+Z4z6iCJ2hzMznUsSVxyF8G3dbZn9pxzffng@mail.gmail.com>
         <CAB4CAwcwVEyFX=7KJcAT9eXQoof_M+U+tB+FRQCnoP5WgK-MrQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: Need support for Intel new wifi module 9462NGW
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Chris,

On Thu, 2017-11-09 at 11:11 +0800, Chris Chiu wrote:
> Hi Luca,
>     Any suggestion for the "Failed to start INIT ucode: -110" issue
> for the firmware?

There were a few problems which should now be fixed.  We published new
firmwares in our linux-firmware.git tree[1] and also made some fixes in
the driver[2].  Please update your system accordingly and let me know
if it works for you.

Thanks!

[1] https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git/
[2] https://patchwork.kernel.org/patch/10059871/
    https://patchwork.kernel.org/patch/10059875/
    https://patchwork.kernel.org/patch/10059873/

--
Cheers,
Luca.
