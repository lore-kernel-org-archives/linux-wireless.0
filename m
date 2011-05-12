Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dell.nexicom.net ([216.168.96.13]:54829 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180Ab1ELByj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 21:54:39 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-124-14.nexicom.net [216.168.124.14])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p4C1sbCN032698
	for <linux-wireless@vger.kernel.org>; Wed, 11 May 2011 21:54:38 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id C205C1E0110
	for <linux-wireless@vger.kernel.org>; Wed, 11 May 2011 21:54:36 -0400 (EDT)
Message-ID: <4DCB3DFF.1030809@lockie.ca> (sfid-20110512_035442_422676_8195932A)
Date: Wed, 11 May 2011 21:55:11 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8192ce.ko doesn't work with 802.11n?
References: <BANLkTikOw0j8hLBRf6m1p7REpJvNf3mqCw@mail.gmail.com>
In-Reply-To: <BANLkTikOw0j8hLBRf6m1p7REpJvNf3mqCw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/11/11 15:29, Flaminigo wrote:
> MY university deployed 802.11n wireless LAN. However, my new T420
> cannot connect to the network under ubuntu 11.04. I found the driver
> for realtek 8188CE is rtl8192ce.ko, rtlwifi. I asked network
> administrator to help me. They told me my wireless adapter didn't work
> well with the 802.11n network. Is this because of the driver? The
> following are the wpa_supplicant output. FYI

Is there another N network you can try (preferably unencrypted)?

Or can you try the card under Windows?

Try a bunch of other distros on livecds (or USBs).

