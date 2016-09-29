Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:34511 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753265AbcI2LcF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Sep 2016 07:32:05 -0400
Received: by mail-wm0-f48.google.com with SMTP id 197so5740345wmk.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Sep 2016 04:32:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANfLQrY6AVJoh8PW+5Ev0seKqnNRxRhK-N735q6Aa4KvdUVEcg@mail.gmail.com>
References: <CANfLQrY6AVJoh8PW+5Ev0seKqnNRxRhK-N735q6Aa4KvdUVEcg@mail.gmail.com>
From: Gucea Doru <gucea.doru@gmail.com>
Date: Thu, 29 Sep 2016 14:32:03 +0300
Message-ID: <CANfLQrZxEUX0UMwrVNZHps9ztqxmOaeovy34fey2NkErCDDarQ@mail.gmail.com> (sfid-20160929_133210_131945_50BCBEE2)
Subject: Re: bcmdhd: Strange Power Save messages
To: Arend van Spriel <arend@broadcom.com>
Cc: Andra Paraschiv <andra.paraschiv7@gmail.com>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 27, 2016 at 12:03 PM, Gucea Doru <gucea.doru@gmail.com> wrote:
> What is the decision triggering the exit from the PS mode immediately
> after the ping request? I am asking this because 802.11 PS legacy
> specifies that the client should wait for a beacon with TIM set in
> order to wake up: in my case, there is no beacon between the ping
> request message and the Null frame that announces the exit from the PS
> mode.


Any help would be highly appreciated :)

IEEE Std 802.11-2012, section 10.2.1.8 specifies that "when the STA
detects that the bit corresponding to its AID is 1 i the TIM, the STA
shall issue a PS Poll". In my capture there are cases when the STA
exits the PS mode without waiting for a beacon.

Thanks!
