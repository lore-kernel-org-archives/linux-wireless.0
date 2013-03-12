Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932304Ab3CLJ6G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 05:58:06 -0400
Date: Tue, 12 Mar 2013 10:58:27 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Pedro Francisco <pedrogfrancisco@gmail.com>
Cc: Krzysztof Kolasa <kkolasa@winsoft.pl>,
	ML linux-wireless <linux-wireless@vger.kernel.org>,
	linville@tuxdriver.com, Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: iwlegacy iwl3945 unable to connect to any hotspots on
 3.9.0-rc1/rc2
Message-ID: <20130312095826.GB1383@redhat.com> (sfid-20130312_105811_123383_5F5BD82F)
References: <513E34FD.8090606@winsoft.pl>
 <CAJZjf_zfi3Eph2nnn+qJfGt3wGWJEFGxLuJtXAnb+s-Q9nrzgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJZjf_zfi3Eph2nnn+qJfGt3wGWJEFGxLuJtXAnb+s-Q9nrzgg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 12, 2013 at 08:30:47AM +0000, Pedro Francisco wrote:
> On Mon, Mar 11, 2013 at 7:48 PM, Krzysztof Kolasa <kkolasa@winsoft.pl> wrote:
> > Hotspots are visible and are working OK but wifi card can't connect.
> >
> 
> Hit this bug also, on the GNOME-3.7.90.iso (based on FC19 testing
> ISO), "Can't stop Rx DMA." and friends.
> 
> iwl3945 was/is working fine on 3.8.
> 
> Krzysztof Kolasa, you may want to see
> http://www.spinics.net/lists/linux-wireless/msg104564.html on
> requested debugging procedure for the problem.

I'm just tested 3.9-rc2 and have the same problems (including
dma map warning). So I don't need debug logs for that.
However still I would like to see 3.8 logs from Zdenek.

Stanislaw
