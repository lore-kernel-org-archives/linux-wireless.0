Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:35669 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464AbcCSNPo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Mar 2016 09:15:44 -0400
Received: by mail-ob0-f171.google.com with SMTP id fp4so140511283obb.2
        for <linux-wireless@vger.kernel.org>; Sat, 19 Mar 2016 06:15:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56ED4595.5050007@users.sourceforge.net>
References: <cover.1458262312.git.julian.calaby@gmail.com> <c95f816da2d5c6789004e063e1b7adc44695718e.1458262312.git.julian.calaby@gmail.com>
 <56ED4595.5050007@users.sourceforge.net>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sun, 20 Mar 2016 00:15:24 +1100
Message-ID: <CAGRGNgVybFMXf-KFBTVEwbbwcqEvP62xGa9LGKcoHJxtLT0Phg@mail.gmail.com> (sfid-20160319_141624_597973_58C16B99)
Subject: Re: [PATCH DETAIL 13/19] rsi: Delete unnecessary variable initialisation
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Markus,

On Sat, Mar 19, 2016 at 11:27 PM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
>> In rsi_send_data_pkt(), the following variables are assigned to
>> before they're used:
>
> Thanks for your interest in this update suggestion.
> How do you think about to add the function name also to such
> a mail subject so that the potential for confusion with an other
> change can be eventually reduced around the source file "rsi_91x_pkt.c"?

I don't think it really matters, they're both doing the same thing.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
