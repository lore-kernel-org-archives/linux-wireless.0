Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44195 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab1HATNo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2011 15:13:44 -0400
Received: by fxh19 with SMTP id 19so4840022fxh.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Aug 2011 12:13:43 -0700 (PDT)
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Daniel Drake <dsd@laptop.org>
Subject: Re: [PATCH 1/2] libertas: disable functionality when interface is down
Date: Mon, 1 Aug 2011 22:13:12 +0300
Cc: libertas-dev@lists.infradead.org, linville@tuxdriver.com,
	dcbw@redhat.com, linux-wireless@vger.kernel.org
References: <20110801154313.8C9389D401F@zog.reactivated.net> <201108012038.40155.anarsoul@gmail.com> <CAGq3pz50EamvOmsshmZaPp5-ToW8eVi78r-BdDG-rX2154sH2A@mail.gmail.com>
In-Reply-To: <CAGq3pz50EamvOmsshmZaPp5-ToW8eVi78r-BdDG-rX2154sH2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201108012213.13032.anarsoul@gmail.com> (sfid-20110801_211347_686173_0B810805)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 01 August 2011 20:50:03 Daniel Drake wrote:
> On 1 August 2011 18:38, Vasily Khoruzhick <anarsoul@gmail.com> wrote:
> >> power_save and power_restore hooks are added meaning that card drivers
> >> can take steps to turn the device off when the interface is down.
> > 
> > You mean completely off? And firmware needs to be reloaded after power
> > up?
> 
> Yep, exactly like that. Same as various mac80211-based drivers.
> 
> The 2nd patch in this series implements it for libertas_sdio, the
> other libertas interfaces have their behaviour as before.

Cool, I hope I'll get some time tomorrow to test your changes with 
libertas_spi.

Regards
Vasily
