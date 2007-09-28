Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.251]:22386 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708AbXI1HoX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2007 03:44:23 -0400
Received: by an-out-0708.google.com with SMTP id d31so431405and
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2007 00:44:22 -0700 (PDT)
Message-ID: <1ba2fa240709280044l53297075j1e8ea9cd3faee10c@mail.gmail.com>
Date: Fri, 28 Sep 2007 09:44:21 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [PATCH] iwlwifi: set fixed rate through debugfs
Cc: "Zhu Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <46FBBD78.2050001@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11908636643693-git-send-email-yi.zhu@intel.com>
	 <11908636753775-git-send-email-yi.zhu@intel.com>
	 <11908636772860-git-send-email-yi.zhu@intel.com>
	 <11908636781043-git-send-email-yi.zhu@intel.com>
	 <1190863679136-git-send-email-yi.zhu@intel.com>
	 <11908636801368-git-send-email-yi.zhu@intel.com>
	 <11908636823439-git-send-email-yi.zhu@intel.com>
	 <20070926213517.042008a9.randy.dunlap@oracle.com>
	 <1190868222.25840.89.camel@debian.sh.intel.com>
	 <46FBBD78.2050001@oracle.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/27/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> Zhu Yi wrote:
> > On Wed, 2007-09-26 at 21:35 -0700, Randy Dunlap wrote:
> >> Is this just for developer/tester debug use, not for normal use?
> >
> > Yeah, this is for developer debug only at this time.
>
> Yes, as long as it's using debugfs, it's forever for developer/tester use.
> You can't expect or require debugfs to be built or mounted for normal use.
>

There is no other intension then debugging for these functions.
Tomas

> --
> ~Randy
> Phaedrus says that Quality is about caring.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
