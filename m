Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40972 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758294Ab1LNWvW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 17:51:22 -0500
Received: by vbbfc26 with SMTP id fc26so1054238vbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Dec 2011 14:51:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1323900627.3599.4.camel@jlt3.sipsolutions.net>
References: <4EE2202A.4080303@gmx.net> <1323446534.13074.96.camel@wwguy-huron>
 <4EE24DF4.4020301@gmx.net> <1323451436.13074.158.camel@wwguy-huron>
 <1323455216.3622.21.camel@jlt3.sipsolutions.net> <4EE35877.1060507@gmx.net>
 <1323680657.3442.7.camel@jlt3.sipsolutions.net> <4EE5D2D3.406@gmx.net>
 <1323684754.3442.36.camel@jlt3.sipsolutions.net> <4EE5E3CD.1070409@gmx.net>
 <1323712082.3442.43.camel@jlt3.sipsolutions.net> <4EE64522.5090107@gmx.net>
 <1323790688.3355.24.camel@jlt3.sipsolutions.net> <4EE8B12C.4090906@gmx.net> <1323900627.3599.4.camel@jlt3.sipsolutions.net>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Wed, 14 Dec 2011 14:51:01 -0800
Message-ID: <CALSq=BauniFumdhaSRXn2myh8oL7=7wFkkXGJFo8mdQYmddFeA@mail.gmail.com> (sfid-20111214_235125_930861_94A97413)
Subject: Re: iwlwifi havoc on some APs (rekeying?)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Wolfgang Breyha <wbreyha@gmx.net>,
	"Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 14, 2011 at 2:10 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> Maybe we somehow invented the best fuzzer ever? Wrongly decrypted
> packets being sent up without being dropped, and your video stream and
> firefox hating random binary data in the middle of the input?
>

Seems unlikely---how would random binary data get properly put into
the right TCP streams...

Dan
