Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io1-f48.google.com ([209.85.166.48]:36294 "EHLO
        mail-io1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbeIGTIE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Sep 2018 15:08:04 -0400
Received: by mail-io1-f48.google.com with SMTP id q5-v6so1671543iop.3
        for <linux-wireless@vger.kernel.org>; Fri, 07 Sep 2018 07:26:53 -0700 (PDT)
MIME-Version: 1.0
References: <CABPxzYK=jmERyvryoy274gtDEBft-BUMjOBsDhjVd+xQu-tQLg@mail.gmail.com>
In-Reply-To: <CABPxzYK=jmERyvryoy274gtDEBft-BUMjOBsDhjVd+xQu-tQLg@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Fri, 7 Sep 2018 19:56:40 +0530
Message-ID: <CABPxzYKUEr1R8Bt+hVNVQr6CoHwSOiTi6-cMFwFiNwzG-VEZDA@mail.gmail.com> (sfid-20180907_162655_877853_0DF0C218)
Subject: Re: ath10k: adding wlan to bridge causes WPA2-PSK to fail
To: "Hostap@lists.infradead.org" <hostap@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 28, 2018 at 9:47 PM Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
>
> Hi,
>
> I am trying to connect ath10k interface to Linux bridge after enabling
> of 4addr mode in WPA2-PSK mode, but EAPOL handshake fails, M1 is
> not received by the wpa_supplicant.
Did not pass "-b br0" to the wpa_supplicant so l2 bridge code is not
initialized.
After passing, it works fine. Thanks.
