Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34633 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab2GRABe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 20:01:34 -0400
Received: by pbbrp8 with SMTP id rp8so1583947pbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jul 2012 17:01:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1342529302-29687-1-git-send-email-ozancag@gmail.com>
References: <1342529302-29687-1-git-send-email-ozancag@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 17 Jul 2012 17:01:14 -0700
Message-ID: <CAB=NE6VrBPTNvpncXth+R9U+H+mHDT4cDmi5JdQ5jxFAFLZtFw@mail.gmail.com> (sfid-20120718_020220_313138_4BF8D86F)
Subject: Re: [PATCH] compat: Use a bash function to colorify the messages
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 17, 2012 at 5:48 AM, Ozan Çağlayan <ozancag@gmail.com> wrote:
> Declare a prettify() function that takes a color and a message
> parameter instead of wrapping every message in the script with
> ANSI codes.
>
> Also add a nocolor mode which will be enabled with the -n flag.
>
> Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>

Thanks, applied and pushed!

  Luis
