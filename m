Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:38959 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaFKFF0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 01:05:26 -0400
Received: by mail-we0-f180.google.com with SMTP id x48so5695270wes.11
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jun 2014 22:05:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6XuAj8jEwLesbSDoyawWh0pWTD-w=L3Jrxx+630QSkm5w@mail.gmail.com>
References: <CANy8jx+RY-_wbX5JqdF_xwyP+2XQ-V9Ae95Y5MOzd=fyir8KTw@mail.gmail.com>
 <CABPxzYK2xZwwQ4h+ifB6KP9wyr39RF2Z6zrsyZ=0CtC+YceRWQ@mail.gmail.com> <CAB=NE6XuAj8jEwLesbSDoyawWh0pWTD-w=L3Jrxx+630QSkm5w@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 11 Jun 2014 10:35:04 +0530
Message-ID: <CABPxzYJud-nmSp3gOxA+cPrZpv2Xgo_B9WeVcAnfkY1DSO_q_Q@mail.gmail.com> (sfid-20140611_070531_737956_1FA68A43)
Subject: Re: max_erip/tx_power not being set correctly
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: John Walker <john@x109.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 11, 2014 at 3:28 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> On Sun, May 25, 2014 at 10:55 AM, Krishna Chaitanya
> <chaitanya.mgit@gmail.com> wrote:
>> https://dev.openwrt.org/browser/trunk/package/kernel/mac80211/patches/005-make-genregdb.awk-skip-antenna-gain.patch?rev=40296
>
> This just ignores antenna gain as it was useless.
That actually fixes the issue of setting tx power :-). In the new
db.txt format there
is tx power is not present, so the awk script parses the tx power as
antenna gain.
