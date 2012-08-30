Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38381 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab2H3VFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 17:05:07 -0400
Date: Thu, 30 Aug 2012 14:06:04 -0700
From: Jonathan Nieder <jrnieder@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com, Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH 04/14] rt2x00: Align rt2500pci GPIOCSR definition with
 datasheet.
Message-ID: <20120830210604.GB158@mannheim-rule.att.net> (sfid-20120830_230513_946280_A7B40355)
References: <1346355248-5331-1-git-send-email-gwingerde@gmail.com>
 <1346355248-5331-2-git-send-email-gwingerde@gmail.com>
 <1346355248-5331-3-git-send-email-gwingerde@gmail.com>
 <1346355248-5331-4-git-send-email-gwingerde@gmail.com>
 <1346355248-5331-5-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1346355248-5331-5-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gertjan van Wingerde wrote:

> Rename GPIOCSR_BIT<x> to GPIOCSR_VAL<x> to represent the actual
> meaning better.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Sounds good.

> Cc: <stable@vger.kernel.org>

Should not be needed.

Thanks,
Jonathan
