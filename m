Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58803 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933120Ab0KQPOx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 10:14:53 -0500
Date: Wed, 17 Nov 2010 10:07:21 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: RA-Jay Hung <Jay_Hung@ralinktech.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH 9/9] rt2x00: Modify rt2x00queue_remove_l2pad to make
 skb->data two-byte alignment
Message-ID: <20101117150721.GD2639@tuxdriver.com>
References: <201011131908.15595.IvDoorn@gmail.com>
 <201011170946.04629.helmut.schaa@googlemail.com>
 <B7288B2B5878D747BA031EF4B170D7F6BC5C60@TWHCMBS01.tw.ralinktech.ad>
 <201011171148.04286.helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201011171148.04286.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 17, 2010 at 11:48:04AM +0100, Helmut Schaa wrote:

> John, should I send a follow-up (with a nice description why it this is needed)
> or are you simply reverting this one?

Is there no chance for a fix in short order?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
