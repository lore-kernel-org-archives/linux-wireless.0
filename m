Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.179]:52941 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbYIVSm4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 14:42:56 -0400
Received: by el-out-1112.google.com with SMTP id z25so388648ele.1
        for <linux-wireless@vger.kernel.org>; Mon, 22 Sep 2008 11:42:55 -0700 (PDT)
Message-ID: <43e72e890809221142i44c8e81apce14c6856a1e87d9@mail.gmail.com> (sfid-20080922_204309_298702_799BCCD1)
Date: Mon, 22 Sep 2008 11:42:55 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Philippe Waroquiers" <philippe.waroquiers@skynet.be>
Subject: Re: prism54 stopped working after upgrade from kernel 2.6.25.14-69.fc8 to 2.6.26.3-14.fc8
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CB9B2237C21D46F3B852E45F75E91C52@soleil>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <CB9B2237C21D46F3B852E45F75E91C52@soleil>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 22, 2008 at 11:38 AM, Philippe Waroquiers
<philippe.waroquiers@skynet.be> wrote:
> With the new kernel 2.6.26.3-14.fc8, I see that the prism54 card looks in a
> correct working mode
> (e.g. /sbin/iwlist wlan0 scan shows good scan results).
> But after that, wpa_supplicant cannot associate (gets a timeout)
> (while it works ok with 2.6.25.14-69.fc8)
> I have put below the output of wpa_supplicant for the bad case
> and for the good case.
>
> What can I do to further see what is going wrong ?

Are you using prism54 or p54 in each kernel?

lsmod | egrep "p54|prism54"

  Luis
