Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56436 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751237AbdIAI5l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Sep 2017 04:57:41 -0400
Date: Fri, 1 Sep 2017 10:57:39 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: RT2870 failure in kernel 4.12.8
Message-ID: <20170901085738.GA18397@redhat.com> (sfid-20170901_105746_039630_3F041CF2)
References: <b08798d4-21eb-6fda-3972-50bc1f4d0e9a@lwfinger.net>
 <20170831075514.GA12340@redhat.com>
 <26ef3184-a19e-1bb7-7aa4-4e8647210763@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <26ef3184-a19e-1bb7-7aa4-4e8647210763@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 31, 2017 at 10:33:28AM -0500, Larry Finger wrote:
> Should the patch to wireless-drivers be annotated with a Stable reference so
> that it is added to 4.12 and 4.13?

According to Documentation/networking/netdev-FAQ.txt networking patches
should not be marked cc:stable, instead a decent commit log should
be written describing a bugfix. Which I believe it is done for
this patch.

Thanks
Stanislaw 
