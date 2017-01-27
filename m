Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36077 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754536AbdA0KHv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2017 05:07:51 -0500
Date: Fri, 27 Jan 2017 10:05:38 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Ming Lei <ming.lei@canonical.com>,
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
Subject: Re: [PATCH 6/6] wl1251: Set generated MAC address back to NVS data
Message-ID: <20170127090538.GB24223@pali> (sfid-20170127_110813_349628_B4D8CD86)
References: <1482598381-16513-1-git-send-email-pali.rohar@gmail.com>
 <1482598381-16513-7-git-send-email-pali.rohar@gmail.com>
 <87inp1ndgm.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <87inp1ndgm.fsf@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 27 January 2017 09:56:09 Kalle Valo wrote:
> Pali Rohár <pali.rohar@gmail.com> writes:
> 
> > In case there is no valid MAC address kernel generates random one. This
> > patch propagate this generated MAC address back to NVS data which will be
> > uploaded to wl1251 chip. So HW would have same MAC address as linux kernel
> > uses.
> >
> > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> 
> Why? What issue does this fix?

Send permanent MAC address to wl1251 chip, same what is doing wl12xx
driver.

-- 
Pali Rohár
pali.rohar@gmail.com
