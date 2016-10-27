Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yb0-f181.google.com ([209.85.213.181]:33969 "EHLO
        mail-yb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942804AbcJ0Oaf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Oct 2016 10:30:35 -0400
Received: by mail-yb0-f181.google.com with SMTP id f97so18900815ybi.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 Oct 2016 07:30:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAMH-ytch0sbtjfp8rjUCNbEkj4euBES7a4n9niS1DtMZk2EKA@mail.gmail.com>
References: <CAAMH-ytch0sbtjfp8rjUCNbEkj4euBES7a4n9niS1DtMZk2EKA@mail.gmail.com>
From: Gary Bisson <gary.bisson@boundarydevices.com>
Date: Thu, 27 Oct 2016 12:45:44 +0200
Message-ID: <CAAMH-yvdCMMqMc5HBGtPTEYFS5s48hyRaBtQdEiM-GCDwbFcrA@mail.gmail.com> (sfid-20161027_163046_881850_87B94FFD)
Subject: Re: Outdated wl12xx firmwares
To: linux-firmware@kernel.org
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Adding linux-wireless in CC, hoping to get more traction.

Just checked the MAINTAINERS file of this driver and it is listed as
'Orphan', so is it ok if a non-TI person submits the up-to-date
firmware files?

Regards,
Gary

On Fri, Oct 14, 2016 at 7:32 PM, Gary Bisson
<gary.bisson@boundarydevices.com> wrote:
> Hi,
>
> I am wondering why the w127x and wl128x firmware files have not been
> updated to their latest version (since Jan 2014)?
>
> The current version in the linux-firmware repo are:
> - 6.3.10.0.133 for single-role
> - 6.5.7.0.42 for multi-role
>
> Looking at TI's forum[1], they recommend using the latest one to avoid
> issues like firmware reload:
> - 6.3.10.0.139 for single-role
> - 6.5.7.0.47 for multi-role
>
> The up-to-date firmware files can be found in the following repo:
> https://github.com/TI-OpenLink/ti-utils/tree/master/hw/firmware
>
> What is the procedure to update them, does it need to be a TI employee
> that sends the patch? The former wl12xx maintainer (Luciano Coelho)
> seems to work for Intel now.
>
> Regards,
> Gary
>
> [1] https://e2e.ti.com/support/wireless_connectivity/wilink_wifi_bluetooth/f/307/p/350832/1236099#1236099
