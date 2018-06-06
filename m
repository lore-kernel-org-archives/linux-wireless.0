Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:34108 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752304AbeFFTsX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Jun 2018 15:48:23 -0400
MIME-Version: 1.0
In-Reply-To: <20180522212932.5357-2-jprvita@endlessm.com>
References: <20180522212932.5357-1-jprvita@endlessm.com> <20180522212932.5357-2-jprvita@endlessm.com>
From: =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>
Date: Wed, 6 Jun 2018 12:47:42 -0700
Message-ID: <CA+A7VXVcvhU293-hhGfkjL1evxVju_XednQySxytjF1gNOFehg@mail.gmail.com> (sfid-20180606_214848_133825_387A78BA)
Subject: Re: [PATCH 2/2] rfkill: Create rfkill-none LED trigger
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux@endlessm.com,
        =?UTF-8?B?TWljaGHFgiBLxJlwaWXFhA==?= <kernel@kempniu.pl>,
        =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@endlessm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 22, 2018 at 2:29 PM, Jo=C3=A3o Paulo Rechi Vita
<jprvita@gmail.com> wrote:
> Creates a new trigger rfkill-none, as a complement to rfkill-any, which
> drives LEDs when any radio is enabled. The new trigger is meant to turn
> a LED ON whenever all radios are OFF, and turn it OFF otherwise.
>

Johannes, do you have any feedback here? This will be used by
asus-wireless in the same way fujitsu-laptop uses rfkill-any.

--
Jo=C3=A3o Paulo Rechi Vita
http://about.me/jprvita
