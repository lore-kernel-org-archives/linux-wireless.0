Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755722AbYDNRPV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2008 13:15:21 -0400
Subject: Re: Alternative Libertas SDIO driver seen
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: David Anders <dave123_aml@yahoo.com>,
	libertas-dev@lists.infradead.org,
	"Harvey, Timothy" <tharvey@irobot.com>, feng.tang@intel.com,
	linux-wireless@vger.kernel.org, claud_yu <claud_yu@yahoo.com.tw>
In-Reply-To: <200804141831.34183.hs4233@mail.mn-solutions.de>
References: <916547.28931.qm@web54407.mail.yahoo.com>
	 <200804141831.34183.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 13:12:29 -0400
Message-Id: <1208193149.31015.58.camel@localhost.localdomain> (sfid-20080414_181526_122384_1784C558)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-04-14 at 18:31 +0200, Holger Schurig wrote:
> > the moblin libertas driver is originally based on source
> > marvell released for both the OLPC and the UMPC
> 
> I understand the history similar to this:
> 
>    Marvell driver developed driver
>         dropped to OLPC
>    Marvell continued internal driver
>         Linux community used OLPC driver and
>         brought it into a linux mainline acceptable form
>    Marvell released 5.0.16 as GPL
>         OLPC driver was massaged to support
>         USB,CF and somwhat to support SDIO
>    Marvell continued internal driver
>         Linux community changed OLPC driver
>    Marvell released v8 to Intel moblinux
>    Marvell continued internal driver
>         Linux community changed OLPC driver
>    Marvell releases v9 to Intel moblinux
> 
> 
> From some perspective, I find the current libertas driver in 
> Linux better (Dan Williams wrote about this).
> 
> However, I'd like to compare an early OLPC driver to the v9 that 
> is in Intel's moblinux tree. This way we can find out what 
> Marvell changed in the meantime and decide which of those 
> changes might be beneficial for us.

WMM and BT coexistance are two big ones so far.

For your reviewing pleasure, from the latest 8686 drop on the Marvell
site against the early 8388 drop on their site, which is essentially
what they tossed over the wall to OLPC in April 2006:

http://people.redhat.com/dcbw/lbs-drivers.diff

Dan


