Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51291 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420AbaGHNOA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2014 09:14:00 -0400
Received: by mail-lb0-f174.google.com with SMTP id u10so3926836lbd.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2014 06:13:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPoQQ-3gvOXmRAqAwuX_sMa6doDo=05r4OCn+CA_J5D67OU-gA@mail.gmail.com>
References: <CAPoQQ-3gvOXmRAqAwuX_sMa6doDo=05r4OCn+CA_J5D67OU-gA@mail.gmail.com>
Date: Tue, 8 Jul 2014 16:13:58 +0300
Message-ID: <CANUX_P0TVuNqbSAHdfn88qCx8QRvWEfCLHTub0EjPL51We3F1w@mail.gmail.com> (sfid-20140708_151404_754736_D8EFC124)
Subject: Re: iwlwifi gets into state where it continually fails to associate
 until the driver is re-bound
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Cody P Schafer <dev@codyps.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 8, 2014 at 8:06 AM, Cody P Schafer <dev@codyps.com> wrote:
> Kernel version: 3.15.3 + 1 patch for some btrfs issues. I've also seen
> this on 3.15.2.
>
> Hardware:
>
> 02:00.0 Network controller: Intel Corporation Centrino Wireless-N 1000
> [Condor Peak]
>         Subsystem: Intel Corporation Centrino Wireless-N 1000 BGN
>         Kernel driver in use: iwlwifi
>         Kernel modules: iwlwifi
>
We already have a bug open on that:
https://bugzilla.kernel.org/show_bug.cgi?id=56581
