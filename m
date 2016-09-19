Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:33879 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758261AbcISLPr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 07:15:47 -0400
Received: by mail-wm0-f46.google.com with SMTP id a25so1577481wmi.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2016 04:15:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMHqqOC5G3w6TnuJp1MWcVpvYkjt5cgpKDwGLi5sEe3-Ud5_HA@mail.gmail.com>
References: <CAMHqqOC5G3w6TnuJp1MWcVpvYkjt5cgpKDwGLi5sEe3-Ud5_HA@mail.gmail.com>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Mon, 19 Sep 2016 13:15:44 +0200
Message-ID: <CA+BoTQk=JU_kjs__cU50Y1Y3E=EjiibbdMj00wp-PrG5+BGtbw@mail.gmail.com> (sfid-20160919_131627_840990_7D551847)
Subject: Re: ath10k inoperatable after suspend
To: Steffen Arntz <winrootkit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 September 2016 at 00:52, Steffen Arntz <winrootkit@gmail.com> wrote:
> Hi at all,
>
> I have an QCA988X based card in my laptop and have some "issues" with
> it, that I was not experiencing with my previous ath9k based card.
>
> The main issue is, that after suspend to RAM the card seems to be
> "hung up" and only reloading ath10k_core and ath10k_pci helps to fix
> the problem.

Hmm.. just a guess - maybe PCI config space isn't well preserved over
suspend and reloading modules prompts the PCI subsys to reset it.


Michal
