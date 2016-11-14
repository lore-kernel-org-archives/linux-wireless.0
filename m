Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:49440 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932343AbcKNIMz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 03:12:55 -0500
Message-ID: <1479109023.2561.6.camel@coelho.fi> (sfid-20161114_091259_164944_B90773C7)
From: Luca Coelho <luca@coelho.fi>
To: Gary Bisson <gary.bisson@boundarydevices.com>,
        linux-firmware@kernel.org, Maxim Altshul <maxim.altshul@ti.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 14 Nov 2016 09:37:03 +0200
In-Reply-To: <CAAMH-yvdCMMqMc5HBGtPTEYFS5s48hyRaBtQdEiM-GCDwbFcrA@mail.gmail.com>
References: <CAAMH-ytch0sbtjfp8rjUCNbEkj4euBES7a4n9niS1DtMZk2EKA@mail.gmail.com>
         <CAAMH-yvdCMMqMc5HBGtPTEYFS5s48hyRaBtQdEiM-GCDwbFcrA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: Outdated wl12xx firmwares
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I'm CCing Maxim, since he seems to be the last developer from TI to
post patches for the WiLink drivers here.


On Thu, 2016-10-27 at 12:45 +0200, Gary Bisson wrote:
> Hi,
> 
> Adding linux-wireless in CC, hoping to get more traction.
> 
> Just checked the MAINTAINERS file of this driver and it is listed as
> 'Orphan', so is it ok if a non-TI person submits the up-to-date
> firmware files?

AFAICT, the license text in the github repository you pointed to is not
exactly the same as the one in linux-firmware.git.  So, not being a
lawyer, I don't know how you could handle that, since the license in
github explicitly says that you need to reproduce that license.


> Regards,
> Gary
> 
> On Fri, Oct 14, 2016 at 7:32 PM, Gary Bisson
> <gary.bisson@boundarydevices.com> wrote:
> > Hi,
> > 
> > I am wondering why the w127x and wl128x firmware files have not been
> > updated to their latest version (since Jan 2014)?
> > 
> > The current version in the linux-firmware repo are:
> > - 6.3.10.0.133 for single-role
> > - 6.5.7.0.42 for multi-role
> > 
> > Looking at TI's forum[1], they recommend using the latest one to avoid
> > issues like firmware reload:
> > - 6.3.10.0.139 for single-role
> > - 6.5.7.0.47 for multi-role
> > 
> > The up-to-date firmware files can be found in the following repo:
> > https://github.com/TI-OpenLink/ti-utils/tree/master/hw/firmware
> > 
> > What is the procedure to update them, does it need to be a TI employee
> > that sends the patch? The former wl12xx maintainer (Luciano Coelho)
> > seems to work for Intel now.

Right, I'm not working for TI anymore, so there's nothing that I can do
for you.  If I were you, I'd keep poking at current TI developers to
see if they can send these new FW versions to linux-firmware.git.  They
probably even have newer versions than the ones published in github.


> > Regards,
> > Gary
> > 
> > [1] https://e2e.ti.com/support/wireless_connectivity/wilink_wifi_bluetooth/f/307/p/350832/1236099#1236099


--
Cheers,
Luca.
