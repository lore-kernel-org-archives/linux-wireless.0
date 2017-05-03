Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48212 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932681AbdECUn7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 May 2017 16:43:59 -0400
Message-ID: <1493844237.5647.9.camel@redhat.com> (sfid-20170503_224432_599830_9DD5B48C)
Subject: Re: mwifiex won't connect to WPA2 anymore
From: Dan Williams <dcbw@redhat.com>
To: Julien Cubizolles <j.cubizolles@free.fr>,
        linux-wireless@vger.kernel.org
Date: Wed, 03 May 2017 15:43:57 -0500
In-Reply-To: <87tw51y91z.fsf@free.fr>
References: <87wpa3kxgi.fsf@free.fr> <87tw51y91z.fsf@free.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-05-03 at 22:33 +0200, Julien Cubizolles wrote:
> Julien Cubizolles <j.cubizolles@free.fr> writes:
> 
> > I can't connect anymore to my home wifi since upgrading my machine
> > from
> > Ubuntu 16.10 to Ubuntu 17.04.
> 
> It turns out that the problem lies with NetworkManager, I managed to
> get
> the wifi working with wpa_supplicant.

That's odd.  Any idea what that was?  MAC randomization?  NM just uses
the supplicant underneath, so there's no particular reason NM wouldn't
work but wpa_supplicant itself would.

Dan
