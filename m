Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35165 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750720AbdALPIa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 10:08:30 -0500
From: "Malinen, Jouni" <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Kushwaha, Purushottam" <pkushwah@qti.qualcomm.com>
Subject: Re: [PATCH 3/3] cfg80211: Specify the reason for connect timeout
Date: Thu, 12 Jan 2017 15:03:34 +0000
Message-ID: <20170112150332.GA19935@jouni.qca.qualcomm.com> (sfid-20170112_160833_926226_20194935)
References: <1483984388-30237-1-git-send-email-jouni@qca.qualcomm.com>
 <1483984388-30237-3-git-send-email-jouni@qca.qualcomm.com>
 <1484141491.29931.10.camel@sipsolutions.net>
 <20170112135843.GB17983@jouni.qca.qualcomm.com>
 <1484229979.5391.5.camel@sipsolutions.net>
 <20170112142926.GA19489@jouni.qca.qualcomm.com>
 <1484231540.5391.6.camel@sipsolutions.net>
In-Reply-To: <1484231540.5391.6.camel@sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 12, 2017 at 03:32:20PM +0100, Johannes Berg wrote:
>=20
> > We don't.. This discussion here is about the C API where we cannot
> > remove the argument from the call without adding yet another inline
> > wrapper, but the actual function that generates the netlink message
> > does not add the timeout reason attribute for success or explicit
> > rejection cases.
>=20
> Ah. But we can just say here then that it's ignored in those cases, and
> not really worry about it?

Sure, I'll update the comment to say that.

--=20
Jouni Malinen                                            PGP id EFC895FA=
