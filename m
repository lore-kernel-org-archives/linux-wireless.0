Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42914 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751510AbdIBIW1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Sep 2017 04:22:27 -0400
Date: Sat, 2 Sep 2017 10:22:24 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: RT2870 failure in kernel 4.12.8
Message-ID: <20170902082223.GA11293@redhat.com> (sfid-20170902_102238_417818_872DC675)
References: <b08798d4-21eb-6fda-3972-50bc1f4d0e9a@lwfinger.net>
 <20170831075514.GA12340@redhat.com>
 <26ef3184-a19e-1bb7-7aa4-4e8647210763@lwfinger.net>
 <20170901085738.GA18397@redhat.com>
 <87y3pymqw2.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87y3pymqw2.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 01, 2017 at 05:31:57PM +0300, Kalle Valo wrote:
> Stanislaw Gruszka <sgruszka@redhat.com> writes:
> 
> > On Thu, Aug 31, 2017 at 10:33:28AM -0500, Larry Finger wrote:
> >> Should the patch to wireless-drivers be annotated with a Stable reference so
> >> that it is added to 4.12 and 4.13?
> >
> > According to Documentation/networking/netdev-FAQ.txt networking patches
> > should not be marked cc:stable, instead a decent commit log should
> > be written describing a bugfix. Which I believe it is done for
> > this patch.
> 
> But that's for net and net-next trees, not for wireless trees. With
> wireless patches we use "Cc: stable@..." references.

Oh, ok. I was confused by below part of
Documentation/process/stable-kernel-rules.rst 
(because wireless drivers are located in drivers/net/)

 - If the patch covers files in net/ or drivers/net please follow netdev stable
   submission guidelines as described in
   Documentation/networking/netdev-FAQ.txt

Thanks
Stanislaw
