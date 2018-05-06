Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:55219 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751204AbeEFNHN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 6 May 2018 09:07:13 -0400
Message-ID: <0f8aaff5ecad8af6d146453d4d3a5d4dd145977b.camel@intel.com> (sfid-20180506_150725_149806_6B649849)
Subject: Re: [linux-firmware] Version in WHENCE file
From: Luciano Coelho <luciano.coelho@intel.com>
To: sedat.dilek@gmail.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 06 May 2018 16:07:10 +0300
In-Reply-To: <CA+icZUXrHmOJPKT0gnym9yOs6Erm3wDOZU3sbr_MGB8pYjfuzA@mail.gmail.com>
References: <CA+icZUXrHmOJPKT0gnym9yOs6Erm3wDOZU3sbr_MGB8pYjfuzA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2018-05-06 at 14:46 +0200, Sedat Dilek wrote:
> Hi Luca,
> 
> I hope I catched the correct MLs (not sure if linux-firmware has a
> ML,
> I did not found any in the MAINTAINERS file).
> 
> I have seen that in the WHENCE file there is "Version" with and
> without ":", mostly iwlwifi ucodes.
> 
> As an example:
> 
>  File: iwlwifi-8265-36.ucode
> -Version 36.e91976c0.0
> +Version: 36.e91976c0.0
> 
> I don't know the workflow: Do you want to fix it in your tree or
> directly in linux-firmware.git upstream?
> My attached patch is against upstream.

Thanks, Sedat!

I'm going to send a new pull-request this week, so I can include your
patch in my tree and as part of the pull-request.

--
Cheers,
Luca.
