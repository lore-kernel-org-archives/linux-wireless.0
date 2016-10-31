Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33840 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S946949AbcJaXyy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Oct 2016 19:54:54 -0400
Received: by mail-pf0-f196.google.com with SMTP id y68so4068618pfb.1
        for <linux-wireless@vger.kernel.org>; Mon, 31 Oct 2016 16:54:54 -0700 (PDT)
Date: Tue, 1 Nov 2016 09:47:08 +1000
From: Barry Day <briselec@gmail.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: John Heenan <john@zgus.com>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8xxxu: Fix for agressive power saving by rtl8723bu
 wireless IC
Message-ID: <20161031234706.GA15054@testbox> (sfid-20161101_005458_708760_833B2D32)
References: <20161031183522.GA13315@cube>
 <wrfj1sywrz2f.fsf@redhat.com>
 <20161031222045.GA14900@testbox>
 <wrfjoa20qgyt.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <wrfjoa20qgyt.fsf@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 31, 2016 at 06:41:30PM -0400, Jes Sorensen wrote:
> Barry Day <briselec@gmail.com> writes:
> > On Mon, Oct 31, 2016 at 05:25:12PM -0400, Jes Sorensen wrote:
> >> As mentioned previously, if this is to be changed here, it has to be
> >> matched in the _stop section too. It also has to be investigated exactly
> >> why this matters for 8723bu. It is possible this matters for other
> >> devices, but we need to find out exactly what causes this not moving a
> >> major block of init code around like this.
> >
> > I've tested this on the 8192e and 8192c. The same problems occurs with the
> > 8192e but not the 8192c. Stopping and restarting wpa_supplicant had
> > no affect on the 8192c ability to connect to an AP.
> 
> Which version of the driver? I did push in some changes for 8192eu
> recently that fixed the issue with 8192eu driver reloading, and I would
> be interested in knowing if this didn't fix the problem for you?
> 
> Second, could we please keep this on the linux-wireless list where it
> belongs. Everybody else doesn't necessarily want to receive a copy via
> netdev and linux-kernel
> 
> Jes

The tests were done with the latest version of rtl8xxxu-devel. I haven't
noticed any occurence of the previous issue with the 8192eu.
