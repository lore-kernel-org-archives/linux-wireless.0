Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:50639
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbXHSSzm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 14:55:42 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 12/30] rt2x00: Store firmware in memory
Date: Sun, 19 Aug 2007 20:54:29 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708192018.30624.IvDoorn@gmail.com> <200708192025.39412.IvDoorn@gmail.com>
In-Reply-To: <200708192025.39412.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708192054.29643.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 19 August 2007 20:25:39 Ivo van Doorn wrote:
> +void rt2x00lib_free_firmware(struct rt2x00_dev *rt2x00dev)
> +{
> +	if (rt2x00dev->fw) {

No !=NULL check is needed.

> +		release_firmware(rt2x00dev->fw);
> +		rt2x00dev->fw = NULL;
> +	}
> +}

-- 
Greetings Michael.
