Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:63751 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757566Ab0FUTlQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 15:41:16 -0400
Received: by pxi12 with SMTP id 12so1525471pxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jun 2010 12:41:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1277147731.3635.12.camel@jlt3.sipsolutions.net>
References: <1274856569-13436-1-git-send-email-emmanuel.grumbach@intel.com>
	<20100618184257.GB6282@tuxdriver.com> <AANLkTimN8oZ63m7cp2lE5MuFiEJ8iAGKswKIENTjIhMg@mail.gmail.com>
	<93781E992CBA7843962D8B0E7D683F3C1172BD0B6D@SC1EXMB-MBCL.global.atheros.com>
	<1277147731.3635.12.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 21 Jun 2010 12:40:55 -0700
Message-ID: <AANLkTinIK6chkb6-scBQfpuVsxzRvk4L3GAsSSfR6Eyr@mail.gmail.com>
Subject: Re: wireless-regdb: Add A band in IL - And general point regarding tx
	power limits in the dbase
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Green <Michael.Green@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	David Quan <David.Quan@atheros.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 21, 2010 at 12:15 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2010-06-21 at 07:51 -0700, Michael Green wrote:
>
>> b) I think all entries in the dbase should be in dBm (not mW).   dBm
>> vs. mW are absolutely equivalent. No reason to retain "mW" unit from
>> the source docs.  I think this was agreed by all before, but wanted to
>> reiterate.
>
> Why? The tools automatically convert one into the other as required, so
> if the source documents state mW it is _much_ easier to retain it for
> future review. Hence I think it should be retained. As you say, it's
> absolutely equivalent, so there's no reason _not_ to retain it as in the
> source.

I think the concern is not that but the other way around -- checking
db.txt against some internal docs which already have stuff in dBm. So
how about a simple solution: we write a script which parses db.txt and
gives you all entries in either format?

  Luis
