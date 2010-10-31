Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:25408 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756026Ab0JaPck (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Oct 2010 11:32:40 -0400
Subject: Re: Deauthentication for reason 6 using Intel 5300 in 2.6.34
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	"Zheng, Jiajia" <jiajia.zheng@intel.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <AANLkTin_dPPk8XBKWjEbuHmQJg3zok5bUcrrn99qV6dn@mail.gmail.com>
References: <4CCCE31A.5030608@lwfinger.net>
	 <AANLkTin_dPPk8XBKWjEbuHmQJg3zok5bUcrrn99qV6dn@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 31 Oct 2010 08:31:40 -0700
Message-Id: <1288539100.14805.16.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rafal,


On Sun, 2010-10-31 at 02:38 -0700, Rafał Miłecki wrote:
> 2010/10/31 Larry Finger <Larry.Finger@lwfinger.net>:
> > A user on the openSUSE forum reports that the connection drops frequently when
> > using 802.11n on a 5300 with a 2.6.34 kernel. It is deauthenticated for reason
> > 6. He was able to stabilize the connection by disabling N mode. I think he used
> > "options iwlagn 11n_disable=1 11n_disable50=1".
> >
> > Is this a known problem? Would the situation be improved by using
> > compat-wireless? If so, is "bleeding-edge" needed?
> 
> It's fu* known problem. Intel doesn't seem to care about users, they
> have fixed firmware but didn't decide to release it for 2 months.
> 
> http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2214#c19
> 

We do care very much, really sorry the delay. we need to pass regulatory
before we can release it. I am doing everything I can to move the
process  as fast as it can.

Wey
 

