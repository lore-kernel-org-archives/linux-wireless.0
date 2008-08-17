Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.178]:62771 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbYHQJFv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Aug 2008 05:05:51 -0400
Received: by ik-out-1112.google.com with SMTP id c28so1793733ika.5
        for <linux-wireless@vger.kernel.org>; Sun, 17 Aug 2008 02:05:49 -0700 (PDT)
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] mac80211 / rt2x00 / rt61 and adhoc status
Date: Sun, 17 Aug 2008 11:05:46 +0200
Cc: "Lars Ericsson" <Lars_Ericsson@telia.com>,
	linux-wireless@vger.kernel.org
References: <057f01c9002b$413b0330$0b3ca8c0@gotws1589>
In-Reply-To: <057f01c9002b$413b0330$0b3ca8c0@gotws1589>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808171105.46498.IvDoorn@gmail.com> (sfid-20080817_110554_601873_BAD1795D)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 17 August 2008, Lars Ericsson wrote:
> Hi,
> 
> What is the expected status of the adhoc function ?
> 
> Have tried using the wpa_supplicant and got the -EBUSY from
> ieee80211_ioctl_siwmode().

As usual: The interface must be down when changing working mode.

> Worked around that and got the rt61 to join an existing adhoc net, but no
> data flow.
> 
> Two tests cases, but same behaviour:
> 1) Linx.git: 2.6.26 and wpa_supplicant 0.5.9
> 2) rt2x00.git: Version 2.2.0 and wpa_supplicant 0.5.9

Are any beacons going out? Is there anything in the logs which
indicates what is happening?

Ivo
