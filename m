Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mk-outboundfilter-6-a-2.mail.uk.tiscali.com ([212.74.114.16]:8787
	"EHLO mk-outboundfilter-6-a-2.mail.uk.tiscali.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbYGZTke (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jul 2008 15:40:34 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: ath9k working, almost
Date: Sat, 26 Jul 2008 20:30:39 +0100
Cc: linux-wireless@vger.kernel.org
References: <200807261742.15693.alistair@devzero.co.uk> <43e72e890807261115r767bcd9bm909769525e10a836@mail.gmail.com>
In-Reply-To: <43e72e890807261115r767bcd9bm909769525e10a836@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807262030.39724.alistair@devzero.co.uk> (sfid-20080726_214039_804579_32B02139)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 26 July 2008 19:15:51 Luis R. Rodriguez wrote:
> On Sat, Jul 26, 2008 at 9:42 AM, Alistair John Strachan
>
> <alistair@devzero.co.uk> wrote:
> > Hi,
> >
> > The newly announced ath9k driver works great on an AR5418 Core 2 Duo
> > Macbook, WPA2-TKIP/AES et al all work fine. It would be good to see this
> > driver in wireless-testing, it completely replaces madwifi for me. I used
> > linux.git (2.6.26) + wireless-testing.git + my-wireless-testing.git with
> > success.
>
> Please keep in mind Linus' tree is just broken for wireless. But glad
> it is working for you after your tremendous strange changes on your
> tree...

I explicitly said I was not using Linus' tree. Perhaps it is a 
misunderstanding on your part. If you use git pull inside a tree that another 
tree was originally forked from, it is much smaller and faster to check out. 
This is the process I was describing. I am pretty sure there are 
no "tremendous strange changes". :-)

Thanks for the driver..

-- 
Cheers,
Alistair.
