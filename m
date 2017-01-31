Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37352 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750822AbdAaHg5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 02:36:57 -0500
Message-ID: <1485848188.26003.54.camel@coelho.fi> (sfid-20170131_083701_406183_39572132)
From: Luca Coelho <luca@coelho.fi>
To: Mel Stimmel <crosscreekconsulting@earthlink.net>,
        linux-wireless@vger.kernel.org, sgruszka@redhat.com
Date: Tue, 31 Jan 2017 09:36:28 +0200
In-Reply-To: <b4724c04-1377-fda3-a65e-8c84fe60838a@earthlink.net>
References: <b4724c04-1377-fda3-a65e-8c84fe60838a@earthlink.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: Intel Pro 4965 wireless
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,


On Mon, 2017-01-30 at 21:04 -0500, Mel Stimmel wrote:
>      I have a problem that recently arose with my Thinkpad model T61 
> running Ubuntu 16.04 with the Intel Pro 4965 installed.
>      This system was working just fine until sometime in Dec., when 
> after one of the routine updates, the software can't see/find/recognize 
> the wireless adapter. It's not the adapter, as if I boot the system from 
> an older CD (show and tell mode) the wifi works just fine.
>      When I do the command LSHW, it shows the driver as iwl4965, and the 
> version as 3.13.0-93-generic.
>      I've been in the computer business since 1958 but are a newby to 
> Linux so don't any/many of the commands and/or it's inner workings.
>      Any help that y'all could provide would be greatly appreciated.

Adding Stanislaw, who is the maintainer of iwlegacy (which is the driver
that supports iwl4965).


--
Cheers,
Luca.
