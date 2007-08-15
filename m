Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:45313 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590AbXHOSEZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 14:04:25 -0400
Received: by fk-out-0910.google.com with SMTP id z23so2983fkz
        for <linux-wireless@vger.kernel.org>; Wed, 15 Aug 2007 11:04:23 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 18/20] mac80211, drivers: remove reset callback
Date: Wed, 15 Aug 2007 20:10:52 +0200
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
References: <20070815144920.135826000@sipsolutions.net> <20070815145049.384297000@sipsolutions.net>
In-Reply-To: <20070815145049.384297000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708152010.52433.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 15 August 2007, Johannes Berg wrote:
> The callback isn't used so remove it.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

ACK for the rt2x00 part.
If reset is permenantly gone, I'll probably move the reset handler
to rt2x00dev.c soon since that is the only place where it is used
at this time.

Ivo
