Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:35099 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab3FKRqb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 13:46:31 -0400
Received: by mail-bk0-f53.google.com with SMTP id e11so3537727bkh.12
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jun 2013 10:46:29 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Subject: Re: [PATCH] carl9170: make use of the new rate control API
Date: Tue, 11 Jun 2013 19:46:22 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nbd@nbd.name, johannes@sipsolutions.net
References: <1370966237-27716-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <1370966237-27716-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201306111946.22682.chunkeey@googlemail.com> (sfid-20130611_194635_172819_2E281405)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, June 11, 2013 05:57:17 PM Thomas Huehn wrote:
> This patch enabels carl9170 to use the new rate table to lookup each
> mrr rate and retry information per packet.

???

carl9170 already supports the new rate control API (Patch from 2013-04-23).
<http://permalink.gmane.org/gmane.linux.kernel.wireless.general/107657>

Can you please tell me what you think is missing?

Regards,
	Chr

