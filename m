Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:52575 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab3EMDaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 May 2013 23:30:14 -0400
Received: by mail-lb0-f172.google.com with SMTP id y6so5935736lbh.31
        for <linux-wireless@vger.kernel.org>; Sun, 12 May 2013 20:30:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <518F701B.2080900@broadcom.com>
References: <CALOB5QZCeC7OTqkw5go6E_KUajVe5GDuCsSsc68cpZqE2YVfRQ@mail.gmail.com>
 <518DF4B1.3020706@broadcom.com> <518ECC39.9090401@gmail.com>
 <CAJ-VmonOuhBgXa3-LkspaCgAAh8Y9Jxejn-McVourzgE-ajHTw@mail.gmail.com> <518F701B.2080900@broadcom.com>
From: JoSH Lehan <krellan@gmail.com>
Date: Sun, 12 May 2013 20:29:53 -0700
Message-ID: <CALOB5QaPzAsYmF0BQX_ubW_Q9eMytk+ojgDHvzjY85NesAV94g@mail.gmail.com> (sfid-20130513_053019_519215_2CF9B0EE)
Subject: Re: Using compat-drivers conflicts with kernel mac80211 and cfg80211
To: Arend van Spriel <arend@broadcom.com>
Cc: Adrian Chadd <adrian@freebsd.org>, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 12, 2013 at 3:34 AM, Arend van Spriel <arend@broadcom.com> wrote:
> On 05/12/2013 02:46 AM, Adrian Chadd wrote:
>> No, you or the vendor should forward port it to linux-next, then you
>> can just pick up the whole driver/framework set from compat-wireless.
>
> That is indeed the approach. So integrate your vendor provided driver into
> your local linux-next tree and create you own compat-drivers package using
> that tree (see [1]). You have to tinker the framework to include that
> driver.

Thanks to both of you for the advice, on what best to do long-term.
Better yet, I should look into the feasibility of upgrading my
embedded system's kernel to something more recent (so that I wouldn't
need to use compat-drivers at all then).

Josh Lehan
