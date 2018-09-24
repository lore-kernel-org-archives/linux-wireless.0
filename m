Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60798 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727579AbeIXUZR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 16:25:17 -0400
Date: Mon, 24 Sep 2018 16:19:33 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: Felix Fietkau <nbd@nbd.name>, Sid Hayn <sidhayn@gmail.com>,
        linux-wireless@vger.kernel.org
Subject: Re: mt76x0 random crashes after c12128ce44b0
Message-ID: <20180924141932.GA5031@redhat.com> (sfid-20180924_162313_163142_A14A28C6)
References: <20180924140701.GA2089@redhat.com>
 <20180924141311.GI783@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180924141311.GI783@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi

On Mon, Sep 24, 2018 at 04:13:11PM +0200, Lorenzo Bianconi wrote:
> On Sep 24, Stanislaw Gruszka wrote:
> > Hi, after -next commit: 
> > 
> > commit c12128ce44b04a987c4eb0f733cc99c4dd50d45a
> > Author: Felix Fietkau <nbd@nbd.name>
> > Date:   Fri Jul 13 16:26:15 2018 +0200
> > 
> >     mt76: use a per rx queue page fragment cache
> > 
> > I have random crashes when load or unlod mt76x0u module.
> > 
> 
> Hi Stanislaw,
> 
> could you please try following patch (I am not 100% sure it fixes the issue)

Still crashes when module is unloaded.

Regards
Stanislaw
