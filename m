Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48200 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750892AbdLAFxP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Dec 2017 00:53:15 -0500
Message-ID: <1512107590.4827.38.camel@coelho.fi> (sfid-20171201_065320_424585_6A667FF0)
From: Luca Coelho <luca@coelho.fi>
To: Chris Chiu <chiu@endlessm.com>
Cc: johannes.berg@intel.com, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org,
        Linux Upstreaming Team <linux@endlessm.com>
Date: Fri, 01 Dec 2017 07:53:10 +0200
In-Reply-To: <CAB4CAweoq=PAqjPW_POLy5+9tHFquunoY6h5xNJ9EU=xY5zcxg@mail.gmail.com>
References: <CAB4CAwdO0dKAinnPk+ihJyDgOJ1z=2D=+pLMrObJYH+QiaDRqA@mail.gmail.com>
         <1509434718.4492.195.camel@coelho.fi>
         <CAB4CAwc43h5g+zLYd3hv=STELNGH+NEeQOMAXd-Gm0xj+TNuyA@mail.gmail.com>
         <1509952948.4492.360.camel@coelho.fi>
         <CAB4CAwc0G0j1zb+Z4z6iCJ2hzMznUsSVxyF8G3dbZn9pxzffng@mail.gmail.com>
         <CAB4CAwcwVEyFX=7KJcAT9eXQoof_M+U+tB+FRQCnoP5WgK-MrQ@mail.gmail.com>
         <1510825750.4011.179.camel@coelho.fi>
         <CAB4CAwfg73wRoNca2GBaMn4eN04vf+uR3xdzYO0UWG1Nmaqo=w@mail.gmail.com>
         <1510901207.4011.197.camel@coelho.fi>
         <CAB4CAwcit2jqHXs7x2cowHdi31OH3wKnmyW4=v-6RGO-+1gjog@mail.gmail.com>
         <CAB4CAwdZHwC0kiaGU5A1u_P8y0anw58o6KiOXAWbjwUtB=uLuQ@mail.gmail.com>
         <1511689749.4011.357.camel@coelho.fi>
         <CAB4CAwf6uBbMgT_=Qb5uo+2g_sNSLdRhnjJt-C9vB6OgSjphyg@mail.gmail.com>
         <CAB4CAweoq=PAqjPW_POLy5+9tHFquunoY6h5xNJ9EU=xY5zcxg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [linuxwifi] Need support for Intel new wifi module 9462NGW
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-12-01 at 13:29 +0800, Chris Chiu wrote:
> Hi Luca,
>     I think the problem is not missing DHCP reply. I installed
> tcpdump
> on the machine with Intel 9461NGW and start monitoring on the wlan
> interface.
> The result is following
> https://gist.github.com/mschiu77/f4cc14ddae6adf137da15675cca59b30
> 
> I also attach the ifconfig result at the end of the above url. Hope
> this can help a little.

Hi Chris,

Sorry for the delay.  We've been testing this internally, but couldn't
reproduce it at first.  The problems seems to be with the firmware that
we released.

I'll provide you an update today or latest by Monday next week.

--
Cheers,
Luca.
