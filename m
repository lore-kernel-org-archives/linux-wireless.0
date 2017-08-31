Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52952 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750733AbdHaHzR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 03:55:17 -0400
Date: Thu, 31 Aug 2017 09:55:15 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: RT2870 failure in kernel 4.12.8
Message-ID: <20170831075514.GA12340@redhat.com> (sfid-20170831_095520_786063_BEC3116A)
References: <b08798d4-21eb-6fda-3972-50bc1f4d0e9a@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b08798d4-21eb-6fda-3972-50bc1f4d0e9a@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 30, 2017 at 12:03:06PM -0500, Larry Finger wrote:
> Stanislaw and Helmut,
> 
> In a bug report at https://bugzilla.suse.com/show_bug.cgi?id=1055826, the OP
> reports that his RT3572 fails to work after an upgrade from the openSUSE
> Tumbleweed kernel 4.12.7 to 4.12.8. I checked the kernel configuration and
> did not see any problems.
> 
> Are you aware of anyone reporting problems with rt2800usb in 4.12.8 kernels?

I think it is the issue addressed by this 4.12 patch:
https://marc.info/?l=linux-wireless&m=150366111408179&w=2 

Patch for 4.13+ kernels is here:
https://marc.info/?l=linux-wireless&m=150367345912061&w=2

Thanks
Stanislaw
