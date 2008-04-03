Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:13034 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760014AbYDCWeh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 18:34:37 -0400
Received: by py-out-1112.google.com with SMTP id u52so4830503pyb.10
        for <linux-wireless@vger.kernel.org>; Thu, 03 Apr 2008 15:34:36 -0700 (PDT)
Message-ID: <43e72e890804031534y2afdc8d4h1154414df2ccdcd3@mail.gmail.com> (sfid-20080403_233444_846145_F41CB236)
Date: Thu, 3 Apr 2008 18:34:35 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Chr <chunkeey@web.de>
Subject: Re: [RFC][PATCH 0/4] p54: various updates
Cc: linux-wireless@vger.kernel.org,
	"Michael Wu" <flamingice@sourmilk.net>,
	"John Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <200804031740.33177.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200804012339.37204.chunkeey@web.de>
	 <43e72e890804021642u4dd7b329w60344c991e2a7e43@mail.gmail.com>
	 <200804031740.33177.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 3, 2008 at 11:40 AM, Chr <chunkeey@web.de> wrote:
> On Thursday 03 April 2008 01:42:59 Luis R. Rodriguez wrote:
>  >
>  > Thanks, can you resend as inline patches so it can help get better
>  > review. Also while you're at it can you stuff all p54 files into its
>  > own folder?
>  hmm, I can.... but:
>  - in which folder? for now.. I put everything into a new one folder named p54,
>   but as you know the fullmac driver has already the prism54 subdirectory...
>   should I put it there? or is this confusing?

p54 directory works nice. Now that you are introducing master mode the
only thing left I think is IBSS compared to prism54, and if that is
done I think we should *consider* removing prism54 driver after one
release cycle of the kernel. I once was told that for some cards the
softmac driver wouldn't work on some fullmac chipsets. I have yet to
hear of someone who found these type of cards though. I know we also
had some WDS code for prism54 lying around, it just never got merged
in because Jeff didn't find it widely used and IIRC it needed a little
more cleanup.

Think you can get IBSS and maybe WDS to work too?

>  - the resulting patch is too big to post it here, ~ 271kb as plaintext...
>   is a bz2 (32kb)  attachment ok too?

Oh OK, I see. Can you perhaps split the big patch up into a few series?

  Luis
