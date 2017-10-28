Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from swan.laptop.org ([18.85.44.157]:46551 "EHLO swan.laptop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750851AbdJ1DoL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Oct 2017 23:44:11 -0400
Date: Sat, 28 Oct 2017 14:44:04 +1100
From: James Cameron <quozl@laptop.org>
To: David Ashley <dashxdr@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: RTL usb adapter question
Message-ID: <20171028034403.GE8920@us.netrek.org> (sfid-20171028_054416_445608_E8D86E53)
References: <CABkE59DHPoLD5PGRHpKMAwy0w3vR9M_qoHEQ1AkK-ELDcUXD9Q@mail.gmail.com>
 <5f907d16-b889-f7c0-0873-880e5c812ab9@lwfinger.net>
 <CABkE59A2Cr5mx3W_rkHj+qDtu6t-MQ2V_sJPfuuqF4vbJ7YfmQ@mail.gmail.com>
 <20171026220013.GC9888@us.netrek.org>
 <CABkE59BgQ-nk-yQ2XY-T2QTfshQghv3zYiyydnj7t0ek7qSCWQ@mail.gmail.com>
 <20171027044149.GG9888@us.netrek.org>
 <CABkE59AL=Cj_AoLo8qk01ia3vaHye29Wje=pPoA_r4mCPq_9mQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CABkE59AL=Cj_AoLo8qk01ia3vaHye29Wje=pPoA_r4mCPq_9mQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 27, 2017 at 10:23:54PM -0500, David Ashley wrote:
> On 10/26/17, James Cameron <quozl@laptop.org> wrote:
> > Interesting, thanks.  It should be a QFN 46 pin chip; you may have
> > counted 15 instead of 14 pins on the long edge.  Send me a photograph
> > of the inside, off-list?
> 
> I uploaded a couple of pictures here:
> http://www.linuxmotors.com/RTL8188CUS/
> 
> You're right, I miscounted, it has 46 pins.

Thanks.  The BZ5JA might be 5V to 3.3V switching voltage regulator,
with inductor above it.

Datasheet shows there is internal non-volatile memory, powered from
pin 27, which has a trace to an external filter capacitor.

The large zero ohm resistor bottom right is interesting; size chosen
for accessibility; probably for fault isolation or qualification.

In summary, the board design is consistent with the datasheet, and
confirms non-volatile memory that will contain configuration data and
probably firmware.

I agree with Larry; try the firmware file.

-- 
James Cameron
http://quozl.netrek.org/
