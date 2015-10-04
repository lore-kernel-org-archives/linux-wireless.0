Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:36484 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbbJDW0l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 18:26:41 -0400
Received: by igcrk20 with SMTP id rk20so49257336igc.1
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2015 15:26:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABAco3Boow_64N33s=mSu0=K38D00a=OsoSQRJUoMN1_qP_3_A@mail.gmail.com>
References: <CABAco3Boow_64N33s=mSu0=K38D00a=OsoSQRJUoMN1_qP_3_A@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 5 Oct 2015 09:26:21 +1100
Message-ID: <CAGRGNgWW3ffJotN9h7nxN-wofOvCpuPtmwtDWs6nE7CRgxCE5g@mail.gmail.com> (sfid-20151005_002644_717320_F1278484)
Subject: Re: [PATCH] Remove superfluous header files
To: Ola Olsson <ola1olsson@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ola,

On Mon, Oct 5, 2015 at 8:08 AM, Ola Olsson <ola1olsson@gmail.com> wrote:
> if.h only contains if_nametoindex and the reverse.
> Lets remove the inclusion in the source files where
> these functions are not called.

Minor note: in the future, you might want to include the name of the
project ("iw") in your subject line, i.e.
[PATCH] iw: Remove superfluous header files

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
