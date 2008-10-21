Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:41757 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729AbYJUSEx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 14:04:53 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 21 Oct 2008 11:04:53 -0700
Date: Tue, 21 Oct 2008 04:04:46 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Marcel Holtmann <holtmann@linux.intel.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Zhu Yi <yi.zhu@intel.com>, Tomas Winkler <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: New Regulatory Domain Api.
Message-ID: <20081021110446.GB8224@tesla> (sfid-20081021_200457_335062_7F1B3220)
References: <1224485431.18024.12.camel@johannes.berg> <43e72e890810192359g2bc75316v49377ddc9eded934@mail.gmail.com> <1224487340.24677.192.camel@debian.sh.intel.com> <1224520999.9386.72.camel@californication> <1224552899.24677.245.camel@debian.sh.intel.com> <43e72e890810201842o44db616ekd8d5bc66cd1006f@mail.gmail.com> <1224554323.24677.248.camel@debian.sh.intel.com> <43e72e890810201937l3be24156t2172590138fda132@mail.gmail.com> <1224572722.27899.87.camel@johannes.berg> <1224607196.9386.91.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1224607196.9386.91.camel@californication>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 21, 2008 at 09:39:56AM -0700, Marcel Holtmann wrote:
> Yeah. A driver for 2.4 GHz hardware should not even think about any
> other channels :)

No, if you have a regulatory SKU on a 2 GHz band card you can declare
it, nothing should prevent it. In your case you do not because of
the card's design but it doesn't mean this is not possible.

  Luis

