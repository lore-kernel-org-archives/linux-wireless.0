Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:64259 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab0IFKV5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Sep 2010 06:21:57 -0400
Received: by qyk33 with SMTP id 33so4143516qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Sep 2010 03:21:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <830552.64105.qm@web56802.mail.re3.yahoo.com>
References: <AANLkTi=5P8N6QDDZkVuFwCMDzBTLsCkiOem0_WwL-hvS@mail.gmail.com>
	<830552.64105.qm@web56802.mail.re3.yahoo.com>
Date: Mon, 6 Sep 2010 12:21:56 +0200
Message-ID: <AANLkTikYVvnar7Z9FgY6AQ=A3g1Xex768U-XwSiDx2Fc@mail.gmail.com>
Subject: Re: rt2x00usb_watchdog_tx_status: Warning - TX queue 2 status timed
 out, invoke forced tx handler
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Walter Goldens <goldenstranger@yahoo.com>
Cc: Michael <msbroadf@gmail.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 6, 2010 at 12:04 PM, Walter Goldens
<goldenstranger@yahoo.com> wrote:
> Is this why the rt307x chips experience considerable amount of packet loss  in managed mode, when connected to an AP? With the rt2870sta drivers and a rt3070 device I experience no packet loss whatsoever. When rt2800usb is being utilized, large amount of packet loss occurs between the client and AP as well as duplicate packets.

Yes those duplicate packets are since a week or 2, but the packet loss
is likely being caused because of this problem.
I am working on reducing the packet loss, without having too much of a
negative impact on TX status reporting.

Ivo
