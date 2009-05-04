Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:37695 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbZEDIv6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 04:51:58 -0400
Subject: Re: [PATCH] add basic support for parsing country information
 element
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1241423924.8683.9.camel@johannes.local>
References: <1241413787-3185-1-git-send-email-marcel@holtmann.org>
	 <1241423772.8683.8.camel@johannes.local>
	 <1241423924.8683.9.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 04 May 2009 01:51:47 -0700
Message-Id: <1241427107.2899.9.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> Everything else looks good.

I re-sent the patches now in a different order so that the WPA stuff is
the latest in case you want extra fixes. I didn't include all defined
ciphers since I would have to dig though specs again. However it should
now be pretty easy to extend it since the basic parsing is available.

This bring iw scan at the same stage what we had with iwlist and so
another piece to deprecate WEXT.

Regards

Marcel


