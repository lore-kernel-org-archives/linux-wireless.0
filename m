Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55582 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab2EGLKb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 07:10:31 -0400
Received: by yhmm54 with SMTP id m54so4011123yhm.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 May 2012 04:10:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FA7A13D.6020405@01019freenet.de>
References: <4FA75983.9040003@01019freenet.de>
	<201205070702.q4772uem002960@mail.maya.org>
	<4FA7A13D.6020405@01019freenet.de>
Date: Mon, 7 May 2012 13:04:29 +0200
Message-ID: <CAGXE3d-pwTraDvC6yOKt7hHPTXL5LtaHFovD_SFmaPgajJbS9g@mail.gmail.com> (sfid-20120507_131034_591594_8EF80298)
Subject: Re: [rt2x00-users] [rt2800pci (AP) - ath9k] 802.11w: broken
 aggregation handling?
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	hostap@lists.shmoo.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, May 7, 2012 at 12:17 PM, Andreas Hartmann
<andihartmann@01019freenet.de> wrote:
> The attached patch seems to enable 802.11w for rt2800pci (AP). It does
> not work for rt2800usb (rt3572 SUPP), even if the set_key error
> disappears (originally the flag IEEE80211_HW_MFP_CAPABLE was set
> unconditionally).

I'm fine with enabling MFP in rt2800pci but I don't know enough about the
necessary requirements.

Jouni, are there any special requirements for MFP?

Thanks,
Helmut
