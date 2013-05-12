Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:63275 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab3ELAqC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 May 2013 20:46:02 -0400
Received: by mail-wg0-f52.google.com with SMTP id k13so5301047wgh.7
        for <linux-wireless@vger.kernel.org>; Sat, 11 May 2013 17:46:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <518ECC39.9090401@gmail.com>
References: <CALOB5QZCeC7OTqkw5go6E_KUajVe5GDuCsSsc68cpZqE2YVfRQ@mail.gmail.com>
	<518DF4B1.3020706@broadcom.com>
	<518ECC39.9090401@gmail.com>
Date: Sat, 11 May 2013 17:46:01 -0700
Message-ID: <CAJ-VmonOuhBgXa3-LkspaCgAAh8Y9Jxejn-McVourzgE-ajHTw@mail.gmail.com> (sfid-20130512_024607_710819_2972F16C)
Subject: Re: Using compat-drivers conflicts with kernel mac80211 and cfg80211
From: Adrian Chadd <adrian@freebsd.org>
To: JoSH Lehan <krellan@gmail.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 11 May 2013 15:54, JoSH Lehan <krellan@gmail.com> wrote:

> Thanks!  So, I'll need to maintain two sets of mac80211/cfg80211
> modules: one for drivers that were compiled along with the kernel, and
> another for drivers that were compiled as part of the compat-drivers
> package.

No, you or the vendor should forward port it to linux-next, then you
can just pick up the whole driver/framework set from compat-wireless.



Adrian
