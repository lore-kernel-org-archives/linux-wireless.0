Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41142 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751835AbdA2RL2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Jan 2017 12:11:28 -0500
Date: Sun, 29 Jan 2017 18:10:01 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Gnedt <david.gnedt@davizone.at>,
        Michal Kazior <michal.kazior@tieto.com>,
        Daniel Wagner <wagi@monom.org>,
        Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sre@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Grazvydas Ignotas <notasas@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/6] wl1251: Use request_firmware_prefer_user() for
 loading NVS calibration data
Message-ID: <20170129171001.GE24047@wotan.suse.de> (sfid-20170129_181305_246491_6F76B7E5)
References: <87tw8lnei3.fsf@codeaurora.org>
 <20170127094342.GC24223@pali>
 <def4c357-64c0-0681-a5d5-f49a6cb84a92@broadcom.com>
 <20170127101043.GD24223@pali>
 <f60cf2c0-bc1e-3a5f-991c-dc6c95a656af@broadcom.com>
 <20170127103408.GG24223@pali>
 <87bmus7mfk.fsf@kamboji.qca.qualcomm.com>
 <20170127115706.GH24223@pali>
 <8737g47kpd.fsf@kamboji.qca.qualcomm.com>
 <20170127131146.GI24223@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20170127131146.GI24223@pali>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 27, 2017 at 02:11:46PM +0100, Pali Rohár wrote:
> So there are only two options:
> 
> 1) Disallow it and so these users will have non-working wifi.
> 
> 2) Allow those data to be used as fallback mechanism.

There is one "custom fallback" user in kernel which we recently
determined was a total mistake. A sysfs interface should have
been defined to enable custom LED settings. Can't a series of
sysfs interfaces be used to enable override ? So is that not a
third option worth consideration?

  Luis
