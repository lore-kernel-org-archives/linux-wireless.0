Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46328 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750769AbdHaIZg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 04:25:36 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: RT2870 failure in kernel 4.12.8
References: <b08798d4-21eb-6fda-3972-50bc1f4d0e9a@lwfinger.net>
        <20170831075514.GA12340@redhat.com>
Date: Thu, 31 Aug 2017 11:25:32 +0300
In-Reply-To: <20170831075514.GA12340@redhat.com> (Stanislaw Gruszka's message
        of "Thu, 31 Aug 2017 09:55:15 +0200")
Message-ID: <87h8wonnyb.fsf@purkki.adurom.net> (sfid-20170831_102541_741193_F473924F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> On Wed, Aug 30, 2017 at 12:03:06PM -0500, Larry Finger wrote:
>> Stanislaw and Helmut,
>> 
>> In a bug report at https://bugzilla.suse.com/show_bug.cgi?id=1055826, the OP
>> reports that his RT3572 fails to work after an upgrade from the openSUSE
>> Tumbleweed kernel 4.12.7 to 4.12.8. I checked the kernel configuration and
>> did not see any problems.
>> 
>> Are you aware of anyone reporting problems with rt2800usb in 4.12.8 kernels?
>
> I think it is the issue addressed by this 4.12 patch:
> https://marc.info/?l=linux-wireless&m=150366111408179&w=2 
>
> Patch for 4.13+ kernels is here:
> https://marc.info/?l=linux-wireless&m=150367345912061&w=2

And the commit is here:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?id=83ec489193894e52bd395eec470f4f7c4286d4a5

-- 
Kalle Valo
