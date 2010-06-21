Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44583 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895Ab0FUTPf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 15:15:35 -0400
Subject: Re: wireless-regdb: Add A band in IL - And general point regarding
 tx power limits in the dbase
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Green <Michael.Green@Atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	David Quan <David.Quan@Atheros.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>
In-Reply-To: <93781E992CBA7843962D8B0E7D683F3C1172BD0B6D@SC1EXMB-MBCL.global.atheros.com>
References: <1274856569-13436-1-git-send-email-emmanuel.grumbach@intel.com>
	 <20100618184257.GB6282@tuxdriver.com>
	 <AANLkTimN8oZ63m7cp2lE5MuFiEJ8iAGKswKIENTjIhMg@mail.gmail.com>
	 <93781E992CBA7843962D8B0E7D683F3C1172BD0B6D@SC1EXMB-MBCL.global.atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Jun 2010 21:15:31 +0200
Message-ID: <1277147731.3635.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-06-21 at 07:51 -0700, Michael Green wrote:

> b) I think all entries in the dbase should be in dBm (not mW).   dBm
> vs. mW are absolutely equivalent. No reason to retain "mW" unit from
> the source docs.  I think this was agreed by all before, but wanted to
> reiterate. 

Why? The tools automatically convert one into the other as required, so
if the source documents state mW it is _much_ easier to retain it for
future review. Hence I think it should be retained. As you say, it's
absolutely equivalent, so there's no reason _not_ to retain it as in the
source.

johannes

