Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45380 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S946043AbcJaWlb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Oct 2016 18:41:31 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Barry Day <briselec@gmail.com>
Cc: John Heenan <john@zgus.com>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8xxxu: Fix for agressive power saving by rtl8723bu wireless IC
References: <20161031183522.GA13315@cube> <wrfj1sywrz2f.fsf@redhat.com>
        <20161031222045.GA14900@testbox>
Date: Mon, 31 Oct 2016 18:41:30 -0400
In-Reply-To: <20161031222045.GA14900@testbox> (Barry Day's message of "Tue, 1
        Nov 2016 08:20:46 +1000")
Message-ID: <wrfjoa20qgyt.fsf@redhat.com> (sfid-20161031_234135_565311_B98E7429)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Barry Day <briselec@gmail.com> writes:
> On Mon, Oct 31, 2016 at 05:25:12PM -0400, Jes Sorensen wrote:
>> As mentioned previously, if this is to be changed here, it has to be
>> matched in the _stop section too. It also has to be investigated exactly
>> why this matters for 8723bu. It is possible this matters for other
>> devices, but we need to find out exactly what causes this not moving a
>> major block of init code around like this.
>
> I've tested this on the 8192e and 8192c. The same problems occurs with the
> 8192e but not the 8192c. Stopping and restarting wpa_supplicant had
> no affect on the 8192c ability to connect to an AP.

Which version of the driver? I did push in some changes for 8192eu
recently that fixed the issue with 8192eu driver reloading, and I would
be interested in knowing if this didn't fix the problem for you?

Second, could we please keep this on the linux-wireless list where it
belongs. Everybody else doesn't necessarily want to receive a copy via
netdev and linux-kernel

Jes
