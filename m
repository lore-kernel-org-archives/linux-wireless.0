Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:55769 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932876Ab1JNQrt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 12:47:49 -0400
Date: Fri, 14 Oct 2011 18:47:24 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH] ssb: Convert to use crc8 code in kernel library
Message-ID: <20111014184724.647ecc32@milhouse> (sfid-20111014_184758_416252_6D58F59A)
In-Reply-To: <4E986392.7020008@lwfinger.net>
References: <4e90ce9a.89uGF659NNpbpyA3%Larry.Finger@lwfinger.net>
	<20111014111103.5658d4aa@mj>
	<4E986392.7020008@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 14 Oct 2011 11:30:10 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> I am pretty sure that the compiler would optimize out the entire htol16_buf 
> routine. After substitution for cpu_to_le16() on a little-endian system, the 
> statement in the while loop becomes '*(buf + size) = *(buf + size)', which is 

(There also is cpu_to_le16s(). Just for the record.)

-- 
Greetings, Michael.
