Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:51618 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933225AbZKXPNf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 10:13:35 -0500
Received: by bwz27 with SMTP id 27so6061516bwz.21
        for <linux-wireless@vger.kernel.org>; Tue, 24 Nov 2009 07:13:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <heeo7d$pg4$1@ger.gmane.org>
References: <hebaok$2ip$1@ger.gmane.org> <heeo7d$pg4$1@ger.gmane.org>
Date: Tue, 24 Nov 2009 10:13:40 -0500
Message-ID: <b6c5339f0911240713y70dc461cp3c9fbb3235eed0ca@mail.gmail.com>
Subject: Re: HTC Hero cannot get an address from an ath5k AP
From: Bob Copeland <me@bobcopeland.com>
To: Simon Farnsworth <simon@farnz.org.uk>
Cc: linux-wireless@vger.kernel.org,
	ath5k-devel <ath5k-devel@lists.ath5k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 23, 2009 at 2:36 PM, Simon Farnsworth <simon@farnz.org.uk> wrote:
> On Sunday 22 November 2009 12:28, Simon Farnsworth wrote:
>
>> My hostapd configuration file is attached; I've checked that I've used the
>> correct WEP key. I can provide any more information that's needed. My
>> controller appears in lspci as:

Hi Simon,

I am sure this is an issue with power saving -- this patch may help
somewhat, but the last time I looked at it, there were still some
additional issues:

http://patchwork.kernel.org/patch/56785/

Also I never did get beacon gating to work wrt the discussion
around the patch.

Unfortunately I'm completely slammed for the next 3-4 weeks until this
semester ends, so unable to do any wireless work.  Would anyone else
care to take a shot at narrowing this down?

-- 
Bob Copeland %% www.bobcopeland.com
