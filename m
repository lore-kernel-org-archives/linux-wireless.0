Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.231]:6509 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbYEGSXI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2008 14:23:08 -0400
Received: by rv-out-0506.google.com with SMTP id l9so495174rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2008 11:23:07 -0700 (PDT)
Message-ID: <4821F389.6070905@gmail.com> (sfid-20080507_202218_707854_B0161418)
Date: Wed, 07 May 2008 11:23:05 -0700
From: John Daiker <daikerjohn@gmail.com>
MIME-Version: 1.0
To: David Woodhouse <David@Woodhou.se>
CC: Dan Williams <dcbw@redhat.com>,
	Markus Becker <mab@comnets.uni-bremen.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	julian.calaby@gmail.com, andreamrl@tiscali.it
Subject: Re: Update: [RFC][PATCH] mrv8k: Driver for "Marvell 88w8335 [Libertas]"
References: <Pine.LNX.4.64.0803191037220.21835@bugs.comnets.uni-bremen.de>	 <200803191124.03743.hs4233@mail.mn-solutions.de>	 <Pine.LNX.4.64.0803281122240.21835@bugs.comnets.uni-bremen.de>	 <1206992394.12973.39.camel@localhost.localdomain>	 <Pine.LNX.4.64.0804030921150.21835@bugs.comnets.uni-bremen.de>	 <1207943754.3364.1.camel@localhost.localdomain>	 <Pine.LNX.4.64.0804140910580.21835@bugs.comnets.uni-bremen.de>	 <1209057222.5224.3.camel@localhost.localdomain> <1209057680.9212.1065.camel@pmac.infradead.org>
In-Reply-To: <1209057680.9212.1065.camel@pmac.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Woodhouse wrote:
> On Thu, 2008-04-24 at 13:13 -0400, Dan Williams wrote:
>   
>> As a note, the driver works a lot better with a 3Com CardBus card than
>> with the Netgear PCI card.  Not sure if firmwares make a difference; I
>> used the firmware from each card's respective driver CD.  I'm trying to
>> clean up some of the bits of the driver.  We should really get a git
>> tree for this though.
>>     
>
> You can create trees in ~/public_git on bombadil.infradead.org if you
> want to, and we can set up shared trees in /srv/git too.
>
>   
Hate to resurrect an old thread, but...

Do we have a git repo for this yet?  I just bought a NetGear WG311v3 PCI 
Card (Marvell 88w8335), and desperately want this card to work.

If the git is created, a pointer would be greatly appreciated.
If not, can this be done (or at least lets get a webserver to the latest 
work being done).

Thanks,
John Daiker
