Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35068 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752457AbdGJJsK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Jul 2017 05:48:10 -0400
MIME-Version: 1.0
In-Reply-To: <20170707140941.122115-1-russell.joyce@york.ac.uk>
References: <20170707140941.122115-1-russell.joyce@york.ac.uk>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Mon, 10 Jul 2017 11:48:08 +0200
Message-ID: <CACna6rzY84oWNMBfP8N4A=Sxst_8b-S+rTbZFQV0yFcOR5MceQ@mail.gmail.com> (sfid-20170710_114848_040317_23B81CBE)
Subject: Re: [PATCH] brcmfmac: added LED triggers for transmit/receive
To: Russell Joyce <russell.joyce@york.ac.uk>
Cc: Alan Millard <alan.millard@york.ac.uk>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        James Hughes <james.hughes@raspberrypi.org>,
        Tobias Klauser <tklauser@distanz.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list@cypress.com,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 July 2017 at 16:09, Russell Joyce <russell.joyce@york.ac.uk> wrote:
> Add three basic LED triggers to brcmfmac, based on those in mac80211: one
> for transmit, one for receive, and one for combined transmit/receive.
>
> Signed-off-by: Russell Joyce <russell.joyce@york.ac.uk>

1) I think most of it should be some cfg80211 shareable code.
2) This "rxtx" while surely present in other places sounds like a
workaround for LED subsystem limitation. Maybe it's time to finally
rework LED triggers.
