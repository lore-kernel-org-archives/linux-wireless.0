Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43708 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757643AbZFRPPo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 11:15:44 -0400
Date: Thu, 18 Jun 2009 11:01:19 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <kalle.valo@nokia.com>,
	"Zhu, Yi" <yi.zhu@intel.com>, "j@w1.fi" <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [ath9k-devel] [PATCH] mac80211: disassociate when switching
	bands  and not scanning
Message-ID: <20090618150119.GD2738@tuxdriver.com>
References: <1244666131-20031-1-git-send-email-lrodriguez@atheros.com> <1244666973.20900.399.camel@rc-desk> <43e72e890906101349t502e9022h16fa79ea512f8b4d@mail.gmail.com> <1244667817.20900.402.camel@rc-desk> <43e72e890906101404l6a8bee67r560f7c8a1c5f8c36@mail.gmail.com> <1244668077.4706.4.camel@johannes.local> <43e72e890906101542l5064384auf027267a3d19f3ee@mail.gmail.com> <43e72e890906101544i22bacc8fxa0a7d045eea50280@mail.gmail.com> <43e72e890906111204g18e71720w97cb2ea346e5d663@mail.gmail.com> <1244753407.20900.456.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1244753407.20900.456.camel@rc-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 11, 2009 at 01:50:07PM -0700, reinette chatre wrote:

> I ran the steps to reproduce on a kernel that is the latest
> wireless-testing + "mac80211: disconnect when user changes channel" +
> "iwlwifi: remove rs_get_rate workaround". Unfortunately I still get the
> rs_get_rate warning. 

Should I merge the ath9k rate series w/o "iwlwifi: remove rs_get_rate
workaround"?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
