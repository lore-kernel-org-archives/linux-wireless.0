Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43776 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab1JON26 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Oct 2011 09:28:58 -0400
Received: by iaek3 with SMTP id k3so3830729iae.19
        for <linux-wireless@vger.kernel.org>; Sat, 15 Oct 2011 06:28:57 -0700 (PDT)
Message-ID: <4E998AA1.4080907@lwfinger.net> (sfid-20111015_152900_954662_8394AD0F)
Date: Sat, 15 Oct 2011 08:29:05 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Pavel Roskin <proski@gnu.org>,
	John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	"zajec5@gmail.com" <zajec5@gmail.com>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ssb: Convert to use crc8 code in kernel library
References: <4e90ce9a.89uGF659NNpbpyA3%Larry.Finger@lwfinger.net> <20111014111103.5658d4aa@mj> <4E986392.7020008@lwfinger.net> <4E9943D5.1060607@broadcom.com>
In-Reply-To: <4E9943D5.1060607@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/15/2011 03:27 AM, Arend van Spriel wrote:
>
> Feedback on the renaming is indeed valid. Passing the word count is
> better here. For brcmsmac I plan to fill the buffer using 8-bit reads
> from SPROM, verify the crc8, and perform the endianess conversion from
> le16 to cpu when crc is ok (actually under review internally).

That sounds like a good plan. When that is posted, I'll study if that kind of 
change makes sense for ssb.

Larry

