Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.191]:9496 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539AbXIRDBf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2007 23:01:35 -0400
Received: by rv-out-0910.google.com with SMTP id k20so1477166rvb
        for <linux-wireless@vger.kernel.org>; Mon, 17 Sep 2007 20:01:35 -0700 (PDT)
Message-ID: <1197ff4c0709172001od75cdeftc396790461d8879d@mail.gmail.com>
Date: Tue, 18 Sep 2007 11:01:34 +0800
From: "Li YanBo" <dreamfly281@gmail.com>
To: "Reuben Lord" <colalord@users.sourceforge.net>
Subject: Re: Airgo AGN300 WiFi Driver Status?
Cc: dreamfly281@users.sourceforge.net,
	"Jeff willam" <angelbane@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <E1IXPCo-0002T4-0i@sc8-sf-web23.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <E1IXPCo-0002T4-0i@sc8-sf-web23.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/18/07, Reuben Lord <colalord@users.sourceforge.net> wrote:
>
> Message body follows:
>
> Hi,
>
> I have an Alienware m9700 which uses the Airgo AGN300 WiFi
> adapter.  I run Kubuntu 7.04 and I am going crazy because
> there is no driver for this adapter available on the
> internet or through Airgo/Qualcomm the manufacturer (or at
> least they claim they don't have a driver to offer).  I am
> wondering what the development status is on this driver that
> you are writing?

For this moment, we just focus on AGN100, and it has been in test
phase, now the AGN100 can work without any encrypt method. but still
very unstable, you can get the newest code from
http://git.sipsolutions.net/agnx.git. when it is stable, the next step
is make AGN300 work, as we know, AGN300 is a enhance version of
AGN100, so it will be relatively easy if we have made AGN100 work
well.

>Also I'm wondering if you need any help?
> Please let me know because I would be interested in hearing
> back from you.  Thank you!

Yes, now only me do the driver development and Jeff do the reverse
engineer work, if you have interesting about any of them, it will be
greatly welcome, it also will speed up to make your AGN300 work. Any
concern, just sent me a mail. :)

Li YanBo
