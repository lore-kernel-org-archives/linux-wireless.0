Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:40134 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751427AbYGUM76 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 08:59:58 -0400
Date: Mon, 21 Jul 2008 09:59:53 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/3] Introducing IWLAGN
Message-ID: <20080721125952.GB12972@khazad-dum.debian.net> (sfid-20080721_150001_974975_EEBBD1F5)
References: <1216597215-19708-1-git-send-email-tomas.winkler@intel.com> <20080721012528.GA6623@khazad-dum.debian.net> <1ba2fa240807210018gbd31c18g59fc08f4a8b2a3ce@mail.gmail.com> <1ba2fa240807210537p66e55407l33662a43e39c106e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240807210537p66e55407l33662a43e39c106e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 21 Jul 2008, Tomas Winkler wrote:
> On Mon, Jul 21, 2008 at 10:18 AM, Tomas Winkler <tomasw@gmail.com> wrote:
> > On Mon, Jul 21, 2008 at 4:25 AM, Henrique de Moraes Holschuh
> > <hmh@hmh.eng.br> wrote:
> >> On Mon, 21 Jul 2008, Tomas Winkler wrote:
> >>> This series of patches renames iwl4965 driver to iwlagn driver
> >>
> >> Maybe MODULE_ALIAS with the old name would be a good idea?
> >
> > I wasn't aware of this one I'll give it a try. Thanks
> 
> It doesn't work much
> if I rename the module name to iwlagn.ko and just add
> MODULE_ALIAS("iwl4965")  or alias line in  /etc/modprobe.conf.  I've
> checked modules.alias it's updated.
> Still modprobe iwl4965 cannot catch it.

Weird, it certainly worked for thinkpad-acpi when I added a
MODULE_ALIAS("ibm_acpi") to it, sometime ago.  Might be userspace breakage.
Note that I did rename everything in the filesystem to thinkpad_acpi.*, and
the only ibm_acpi left was the one in MODULE_ALIAS.

> If someone have more insight into this networks scripting  I will be greatfull

I am curious as to why it failed, as well.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
