Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.186]:12716 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbZBKVqn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 16:46:43 -0500
Received: by rn-out-0910.google.com with SMTP id k40so451137rnd.17
        for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 13:46:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1234379981.4789.7.camel@localhost>
References: <1234202993.21570.18.camel@localhost>
	 <43e72e890902091020p65235e3ds833560974c785318@mail.gmail.com>
	 <1234203811.21570.19.camel@localhost>
	 <20090209183924.GA6069@tuxdriver.com>
	 <1234207263.6694.1.camel@localhost>
	 <1234208152.6694.4.camel@localhost> <20090210013941.GA4386@tesla>
	 <1234230689.3793.15.camel@localhost> <20090210020708.GC4386@tesla>
	 <1234379981.4789.7.camel@localhost>
Date: Wed, 11 Feb 2009 13:46:40 -0800
Message-ID: <43e72e890902111346p4a689c9bvdb891eab388c5154@mail.gmail.com> (sfid-20090211_224646_429225_044892E1)
Subject: Re: IWL5300, 2.6.29-rc4, CRDA 1.0.1: Missing out 802.11A frequency
	ranges
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: tony@linx.net
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	reinette chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 11, 2009 at 11:19 AM, Tony Vroon <tony@linx.net> wrote:
> Clear run, haven't touched iw, still no 802.11A spectrum. dmesg
> attached. Any suggestion for a workaround that will get me my networks
> back please? (Besides enabling the old regulatory options, which is
> scheduled to be taken away from me soon)

Looks good here -- can you please provide 'iw list' output prior to
trying to associate.

 Luis
