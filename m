Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:35228 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757700Ab0FURMH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 13:12:07 -0400
Received: by wwb13 with SMTP id 13so663910wwb.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jun 2010 10:12:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <93781E992CBA7843962D8B0E7D683F3C1172BD0B6D@SC1EXMB-MBCL.global.atheros.com>
References: <1274856569-13436-1-git-send-email-emmanuel.grumbach@intel.com>
	<20100618184257.GB6282@tuxdriver.com>
	<AANLkTimN8oZ63m7cp2lE5MuFiEJ8iAGKswKIENTjIhMg@mail.gmail.com>
	<93781E992CBA7843962D8B0E7D683F3C1172BD0B6D@SC1EXMB-MBCL.global.atheros.com>
Date: Mon, 21 Jun 2010 20:12:04 +0300
Message-ID: <AANLkTinGczUb2xTX5RUtnrRnc2BitOjZnpkDeHPV9Hwf@mail.gmail.com>
Subject: Re: wireless-regdb: Add A band in IL - And general point regarding tx
	power limits in the dbase
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Michael Green <Michael.Green@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	David Quan <David.Quan@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 21, 2010 at 17:51, Michael Green <Michael.Green@atheros.com> wrote:
> Here are my comments on the proposed patch...
>
> country IL:
>> >       (2402 - 2482 @ 40), (N/A, 20)
>> > +     (5150 - 5250 @ 40). (N/A, 200 mW), NO-OUTDOOR
>> > +     (5250 - 5350 @ 40). (N/A, 200 mW), NO-OUTDOOR, DFS
>


> b) I think all entries in the dbase should be in dBm (not mW).   dBm vs. mW are absolutely equivalent. No reason to retain "mW" unit from the source docs.  I think this was agreed by all before, but wanted to reiterate.

Can you please help me translation from mW to db ?

Thanks
