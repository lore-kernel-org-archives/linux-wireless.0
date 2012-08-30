Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59281 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab2H3VEa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 17:04:30 -0400
Date: Thu, 30 Aug 2012 14:05:23 -0700
From: Jonathan Nieder <jrnieder@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com, Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH 02/14] rt2x00: Align rt2400pci GPIOCSR definition with
 datasheet.
Message-ID: <20120830210522.GA158@mannheim-rule.att.net> (sfid-20120830_230435_373704_11559E57)
References: <1346355248-5331-1-git-send-email-gwingerde@gmail.com>
 <1346355248-5331-2-git-send-email-gwingerde@gmail.com>
 <1346355248-5331-3-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1346355248-5331-3-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Gertjan van Wingerde wrote:

> Datasheet indicates additional fields to set the GPIO direction.
> At the same time rename GPIOCSR_BIT<x> to GPIOCSR_VAL<x> to represent the
> actual meaning better.

Micronit: could the latter be split into a separate patch from the
former, to make life easier e.g. when bisecting?

Only the first part would be needed for stable@.

Thanks,
Jonathan
