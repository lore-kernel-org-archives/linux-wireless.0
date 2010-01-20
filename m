Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:40679 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334Ab0ATKwR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2010 05:52:17 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH 5/5 V2] b43: N-PHY: silence warnings, add missing call
Date: Wed, 20 Jan 2010 11:52:18 +0100
Cc: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <op.u6o9unx49lhzdc@linux-g0th.site> <20100119215528.GB3078@tuxdriver.com> <b170af451001191459u37b53aeag835c1a5e873791a9@mail.gmail.com>
In-Reply-To: <b170af451001191459u37b53aeag835c1a5e873791a9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201001201152.18351.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 19 January 2010 23:59:32 Rafał Miłecki wrote:
> Out of curiosity, could someone tell what Opera does incorrectly when
> sending patches?

They are base64 encoded.
We use a 7 or 8bit encoding for our mails.
I think that opera automatically switches to base64 encoding due to
the special characters in your first and last name.

-- 
Greetings, Michael.
