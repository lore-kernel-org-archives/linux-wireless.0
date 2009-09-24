Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:39789 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbZIXQT7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 12:19:59 -0400
Date: Thu, 24 Sep 2009 18:19:59 +0200
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Mattia Dongili <malattia@linux.it>,
	"Almer S. Tigelaar" <almer@gnome.org>,
	Matthias Welwarsky <matze@welwarsky.de>
Subject: Re: rfkill hard state after booting
Message-ID: <20090924161959.GA26101@gamma.logic.tuwien.ac.at>
References: <20090924130231.GU21590@gamma.logic.tuwien.ac.at> <1253801252.3868.108.camel@johannes.local> <4ABB89B2.8070302@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4ABB89B2.8070302@tuffmail.co.uk>
From: Norbert Preining <preining@logic.at>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Do, 24 Sep 2009, Alan Jenkins wrote:
> +	sony_call_snc_handle(0x124, 0x200, &result);
> +	hwblock = !(result & 0x1);
> +	rfkill_set_hw_state(rfk, hwblock);
> +

I confirm that the (full) patch fixed that problem. Thanks!

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
GOLANT (adj.)
Blank, sly and faintly embarrassed. Pertaining to the expression seen
on the face of someone who has clearly forgotten your name.
			--- Douglas Adams, The Meaning of Liff
