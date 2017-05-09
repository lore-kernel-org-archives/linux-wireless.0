Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:36060 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750805AbdEIRu1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 May 2017 13:50:27 -0400
Received: by mail-wr0-f173.google.com with SMTP id l50so9323482wrc.3
        for <linux-wireless@vger.kernel.org>; Tue, 09 May 2017 10:50:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1863250.VEhGCjvYY0@prime>
References: <20170323133048.30062-2-sw@simonwunderlich.de> <1811221.G4Vz0DPyQ8@prime>
 <12133a0e-b030-5b21-8de1-3bf7334d47df@fit.fraunhofer.de> <1863250.VEhGCjvYY0@prime>
From: Adrian Chadd <adrian@freebsd.org>
Date: Tue, 9 May 2017 10:50:25 -0700
Message-ID: <CAJ-Vmonxt8BmpL+mM07f4-TLU+LKW+eg1Ri3twcrFOKWp9NXLw@mail.gmail.com> (sfid-20170509_195031_736112_4C1A4A64)
Subject: Re: [v2,1/3] ath9k: Support channels in licensed bands
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>,
        Julian Calaby <julian.calaby@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        Steve deRosier <derosier@gmail.com>,
        Ben Greear <greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 May 2017 at 05:57, Simon Wunderlich <sw@simonwunderlich.de> wrote:
> Hey Kalle,
>
> it seems like there was some discussion here and I wouldn't expect too many
> more opinions ... do you think we can have a decision based on what has been
> discussed here?

(Note: FreeBSD has had in-tree support for 4.9GHz and 900MHz bands
since forever. I'm actually thinking of extending it to include 5.9
and other UHF bands to cover licenced hardware people are making but
then leaving the support disabled unless you compile in very specific
licenced bits. No, it doesn't work out of the box unless your NIC
actually supports it in the calibration section.)

(Note note: some of those channels have non-megahertz boundaries,
which means ... yeah, hello inter-operability boundaries. Hilarious.)



-adrian
