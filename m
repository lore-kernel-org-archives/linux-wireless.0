Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59561 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759782Ab0JFSpa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 14:45:30 -0400
Received: by iwn5 with SMTP id 5so10068670iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Oct 2010 11:45:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CACA3D7.90108@candelatech.com>
References: <4CACA3D7.90108@candelatech.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 6 Oct 2010 11:45:09 -0700
Message-ID: <AANLkTimB7=odPK3qTAhFBdzaMFFGVar0kyMrb-p9SgYy@mail.gmail.com>
Subject: Re: Any /n NICs that support APs and multiple STAs other than ath9k?
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 6, 2010 at 9:29 AM, Ben Greear <greearb@candelatech.com> wrote:
> I would like to have a different hardware/driver combination to try
> to tie-break whether bugs are in mac80211 or in the ath9k driver/hardware.
>
> I don't mind doing a bit of driver hacking so long as the basic support
> is there (I think it's mostly the ability to set a BSSID mask and rxfilter
> accordingly).

Your best bet is to test against mac80211_hwsim, that would rule out
any hardware. I think Jouni and Johannes have also a way to get the
devices to talk to each other. Perhaps some documentation of that on
the kernel Documentation/networking/mac80211_hwsim/

  Luis
