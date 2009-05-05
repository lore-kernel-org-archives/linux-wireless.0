Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:33001 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753534AbZEEIfZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 04:35:25 -0400
Date: Tue, 5 May 2009 11:35:16 +0300
From: Jouni Malinen <j@w1.fi>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] add support for parsing WPA and RSN/WPA2 information
	elements
Message-ID: <20090505083516.GA30908@jm.kir.nu>
References: <1241412381-2778-1-git-send-email-marcel@holtmann.org> <20090504080658.GA3141@jm.kir.nu> <1241427204.2899.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1241427204.2899.11.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 04, 2009 at 01:53:24AM -0700, Marcel Holtmann wrote:

> we can add them later. I just wanna have basic support for parsing the
> WPA IE. However can you point me to download links for the specs. I get
> easily lost in the amount of WiFi/802.11 specs.

IEEE 802.11r-2008 is available through the GetIEEE 802 Program
(http://standards.ieee.org/getieee802/802.11.html), but IEEE 802.11w
drafts are not yet publicly available (i.e., only for IEEE 802.11 WG
members at this point). Anyway, as far as the RSN IE assigned values are
concerned, you can get the latest information from the IEEE 802.11 ANA
database:
https://mentor.ieee.org/802.11/dcn/09/11-09-0031-04-0000-ana-database-assigned-number-authority.xls

(the 7.3.2.25.* tabs are for RSN IE)

-- 
Jouni Malinen                                            PGP id EFC895FA
