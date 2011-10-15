Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:49319 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab1JONxc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Oct 2011 09:53:32 -0400
Date: Sat, 15 Oct 2011 15:53:06 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Arend van Spriel <arend@broadcom.com>,
	Pavel Roskin <proski@gnu.org>,
	John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	"zajec5@gmail.com" <zajec5@gmail.com>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ssb: Convert to use crc8 code in kernel library
Message-ID: <20111015155306.6bd1e695@milhouse> (sfid-20111015_155335_596095_052AB28F)
In-Reply-To: <4E998AA1.4080907@lwfinger.net>
References: <4e90ce9a.89uGF659NNpbpyA3%Larry.Finger@lwfinger.net>
	<20111014111103.5658d4aa@mj>
	<4E986392.7020008@lwfinger.net>
	<4E9943D5.1060607@broadcom.com>
	<4E998AA1.4080907@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 15 Oct 2011 08:29:05 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> > I plan to fill the buffer using 8-bit reads from SPROM,

> That sounds like a good plan. When that is posted, I'll study if that kind of 
> change makes sense for ssb.

If this change is made, it has to be tested on all supported devices, IMO.
I would not be surprised if there are older devices that don't like that.

-- 
Greetings, Michael.
