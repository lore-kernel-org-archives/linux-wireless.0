Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53605 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416Ab1LPIOW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 03:14:22 -0500
Received: by pbdu13 with SMTP id u13so628942pbd.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Dec 2011 00:14:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1323968408.31153.1.camel@jlt3.sipsolutions.net>
References: <CAGXE3d9dCL+tnXg5ero51cxf3T9VPVgv8oKo51Vi_gWd8as9Xw@mail.gmail.com>
	<1323968408.31153.1.camel@jlt3.sipsolutions.net>
Date: Fri, 16 Dec 2011 09:14:21 +0100
Message-ID: <CAGXE3d8iseEhF2+w2riO=w_aMDdi8Uv4+w7URCM+PxYG19eYww@mail.gmail.com> (sfid-20111216_091431_633408_62630A4F)
Subject: Re: QoS frames in AP mode?
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 15, 2011 at 6:00 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:

>>         /* skb->priority values from 256->263 are magic values to
>>          * directly indicate a specific 802.1d priority.  This is used
>>          * to allow 802.1d priority to be passed directly in from VLAN
>>          * tags, etc.
>>          */
>>         if (skb->priority >= 256 && skb->priority <= 263)
>>                 return skb->priority - 256;

Is this code still valid? I haven't found a reference in the 802.1q code :(

Helmut
