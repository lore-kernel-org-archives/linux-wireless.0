Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:44446 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbZEEP4U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 11:56:20 -0400
Subject: Re: [PATCH] add support for parsing WPA and RSN/WPA2 information
 elements
From: Marcel Holtmann <marcel@holtmann.org>
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090505083516.GA30908@jm.kir.nu>
References: <1241412381-2778-1-git-send-email-marcel@holtmann.org>
	 <20090504080658.GA3141@jm.kir.nu>
	 <1241427204.2899.11.camel@localhost.localdomain>
	 <20090505083516.GA30908@jm.kir.nu>
Content-Type: text/plain
Date: Tue, 05 May 2009 08:56:05 -0700
Message-Id: <1241538965.2987.6.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni,

> > we can add them later. I just wanna have basic support for parsing the
> > WPA IE. However can you point me to download links for the specs. I get
> > easily lost in the amount of WiFi/802.11 specs.
> 
> IEEE 802.11r-2008 is available through the GetIEEE 802 Program
> (http://standards.ieee.org/getieee802/802.11.html), but IEEE 802.11w
> drafts are not yet publicly available (i.e., only for IEEE 802.11 WG
> members at this point). Anyway, as far as the RSN IE assigned values are
> concerned, you can get the latest information from the IEEE 802.11 ANA
> database:
> https://mentor.ieee.org/802.11/dcn/09/11-09-0031-04-0000-ana-database-assigned-number-authority.xls
> 
> (the 7.3.2.25.* tabs are for RSN IE)

thanks for the pointers, but I do leave this now for someone else to
fix. The basic RSN parsing code is in iw now and adding new ciphers etc.
is pretty simple :)

Regards

Marcel


