Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f50.google.com ([209.85.216.50]:51175 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161534Ab3FUXee (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jun 2013 19:34:34 -0400
Received: by mail-qa0-f50.google.com with SMTP id l18so1007448qak.2
        for <linux-wireless@vger.kernel.org>; Fri, 21 Jun 2013 16:34:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51C2A567.2010409@rempel-privat.de>
References: <1DC40B07CD6EC041A66726C271A73AE61AA312F5@IRSMSX102.ger.corp.intel.com>
	<51C1B467.1030509@rempel-privat.de>
	<20130619140905.GA14079@zenon.in.qult.net>
	<1371651073.8349.19.camel@jlt4.sipsolutions.net>
	<51C1C95C.8030301@rempel-privat.de>
	<20130619175939.GA19405@zenon.in.qult.net>
	<20130619180354.GB19405@zenon.in.qult.net>
	<51C1FA76.3090109@rempel-privat.de>
	<20130619193316.GA29582@zenon.in.qult.net>
	<51C2942A.2080706@rempel-privat.de>
	<20130620063925.GA3885@zenon.in.qult.net>
	<51C2A567.2010409@rempel-privat.de>
Date: Fri, 21 Jun 2013 19:34:33 -0400
Message-ID: <CA++BO6SiZ6znCpWJqW6A=u+9UPMikJM=1FLS+g4a=3tFKTzefA@mail.gmail.com> (sfid-20130622_013439_909975_E51E5EF3)
Subject: Re: [ath9k-devel] ath9k_htc: station unable to authenticate
From: Corey Richardson <corey@octayn.net>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: Ignacy Gawedzki <i@lri.fr>,
	Johannes Berg <johannes@sipsolutions.net>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 20, 2013 at 2:47 AM, Oleksij Rempel <linux@rempel-privat.de> wrote:
> Question to Corey,
>
> i assume your old AP was supporting only BG networks. And your new one,
> which is working fine, supports N?
>

Yes, this is true. It was also using TKIP encryption, if that is relevant.
