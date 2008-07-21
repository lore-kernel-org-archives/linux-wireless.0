Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:1525 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbYGUMhW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 08:37:22 -0400
Received: by py-out-1112.google.com with SMTP id p76so1021181pyb.10
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2008 05:37:22 -0700 (PDT)
Message-ID: <1ba2fa240807210537p66e55407l33662a43e39c106e@mail.gmail.com> (sfid-20080721_143726_224617_AF51996C)
Date: Mon, 21 Jul 2008 15:37:21 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: [PATCH 0/3] Introducing IWLAGN
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240807210018gbd31c18g59fc08f4a8b2a3ce@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1216597215-19708-1-git-send-email-tomas.winkler@intel.com>
	 <20080721012528.GA6623@khazad-dum.debian.net>
	 <1ba2fa240807210018gbd31c18g59fc08f4a8b2a3ce@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 21, 2008 at 10:18 AM, Tomas Winkler <tomasw@gmail.com> wrote:
> On Mon, Jul 21, 2008 at 4:25 AM, Henrique de Moraes Holschuh
> <hmh@hmh.eng.br> wrote:
>> On Mon, 21 Jul 2008, Tomas Winkler wrote:
>>> This series of patches renames iwl4965 driver to iwlagn driver
>>
>> Maybe MODULE_ALIAS with the old name would be a good idea?
>
> I wasn't aware of this one I'll give it a try. Thanks

It doesn't work much
if I rename the module name to iwlagn.ko and just add
MODULE_ALIAS("iwl4965")  or alias line in  /etc/modprobe.conf.  I've
checked modules.alias it's updated.
Still modprobe iwl4965 cannot catch it.
So it's still will create mess when switching between to version of the kernel.

If someone have more insight into this networks scripting  I will be greatfull
Thanks
Tomas
