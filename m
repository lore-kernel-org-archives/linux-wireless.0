Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:65369 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab3IITPd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 15:15:33 -0400
Received: by mail-wg0-f45.google.com with SMTP id y10so5753552wgg.12
        for <linux-wireless@vger.kernel.org>; Mon, 09 Sep 2013 12:15:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <522E1D31.2090403@candelatech.com>
References: <522E1D31.2090403@candelatech.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 10 Sep 2013 00:45:12 +0530
Message-ID: <CABPxzYLaLUdCXULmx7mV5Gk7L_RrnG4Zq-vO6XRCUt0pvm9SJA@mail.gmail.com> (sfid-20130909_211536_124031_CE6E7F09)
Subject: Re: Always send management frames at MCS-0??
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 10, 2013 at 12:40 AM, Ben Greear <greearb@candelatech.com> wrote:
> I had a user request that we support always sending management frames
> (such as EAPOL) at the lowest rate.  Evidently, other equipment does this,
> where as normal-ish supplicant/linux tends to send them at much higher
> rates.
>
> Any suggestions on how to go about doing this properly?
>
> Any opinions on whether it's a good idea or not?

EAPOL frames are data frams from WLAN perspective
and are unicast, thats why we send at highest possible
MCS supported. There is no advantage in forcing them to
go at lower rates.
