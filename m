Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43237 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbcE0PwS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2016 11:52:18 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Mikael Kanstrup <mikael.kanstrup@gmail.com>
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky \(Zhenhui\) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Subject: Re: [RFCv2] brcmfmac: Add tracepoints for bcmdhd-dissector tool
References: <CACZXzRAVUoStnsBfAsPipangkPmXjUg4vYxENMEb15tnYjxk-g@mail.gmail.com>
Date: Fri, 27 May 2016 18:52:11 +0300
In-Reply-To: <CACZXzRAVUoStnsBfAsPipangkPmXjUg4vYxENMEb15tnYjxk-g@mail.gmail.com>
	(Mikael Kanstrup's message of "Fri, 27 May 2016 16:24:35 +0200")
Message-ID: <87oa7r4hxw.fsf@kamboji.qca.qualcomm.com> (sfid-20160527_175222_312733_1BB31F06)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mikael Kanstrup <mikael.kanstrup@gmail.com> writes:

> Add hexdump tracepoints to be used bcmdhd-dissector:
>   https://github.com/kanstrup/bcmdhd-dissector
>
> bcmdhd-dissector is a Wireshark LUA plugin dissector used to decode
> protocol data between the brcmfmac driver and the wifi chip firmware.
> This includes decoding firmware command requests and responses as
> well as events and even tx/rx data interleaved if the data_dump
> tracepoint is enabled.
>
> Signed-off-by: Mikael Kanstrup <mikael.kanstrup@gmail.com>
> ---
> v2:
> - Add description of bcmdhd-dissector as suggested by Rafał
> - Fix tx/rx data dump.
> - Fix tx data dump on USB interface.
>
> Also updated the github project page with some screenshots.

The patch looks corrupted, did you use git-send-email?

$ git am -s -3 mikael.mbox
Applying: brcmfmac: Add tracepoints for bcmdhd-dissector tool
fatal: corrupt patch at line 31

You can test this yourself by downloading the mbox patchwork (or mailing
it to you directly) and trying apply it to your tree:

https://patchwork.kernel.org/patch/9138515/

-- 
Kalle Valo
