Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64233 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab2HFTUc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 15:20:32 -0400
Received: by obbuo13 with SMTP id uo13so6299149obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 12:20:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1344251193-18733-1-git-send-email-ozancag@gmail.com>
References: <1344251193-18733-1-git-send-email-ozancag@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Mon, 6 Aug 2012 12:20:11 -0700
Message-ID: <CAB=NE6WNRwahAXM8=XTFmkFMViBKVM7vXBj-oFYHdgzGo6919g@mail.gmail.com> (sfid-20120806_212035_222139_C829F3DE)
Subject: Re: [PATCH] compat: backport PCIe register definitions
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 6, 2012 at 4:06 AM, Ozan Çağlayan <ozancag@gmail.com> wrote:
> New DRM core in 3.6 needs these in order to detect the maximum
> link speed of the underlying bus.
>
> This backports:
>
>         commit cdcac9cd7741af2c2b9255cbf060f772596907bb
>         Author: Dave Airlie <airlied@redhat.com>
>         Date:   Wed Jun 27 08:35:52 2012 +0100
>
>             pci_regs: define LNKSTA2 pcie cap + bits.
>
>             We need these for detecting the max link speed for drm drivers.
>
>             Acked-by: Bjorn Helgaas <bhelgass@google.com>
>             Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> [root@ozan linux-2.6]# git describe --contains cdcac9cd
> v3.6-rc1~83^2~26
>
> Trying kernel 3.5.0-030500-generic [OK]
> Trying kernel 3.4.4-030404-generic [OK]
> Trying kernel 3.3.7-030307-generic [OK]
> Trying kernel 3.2.2-030202-generic [OK]
> Trying kernel 3.1.10-030110-generic [OK]
> Trying kernel 3.0.18-030018-generic [OK]
> Trying kernel 2.6.39-02063904-generic [OK]
> Trying kernel 2.6.38-02063808-generic [OK]
> Trying kernel 2.6.37-02063706-generic [OK]
> Trying kernel 2.6.36-02063604-generic [OK]
> Trying kernel 2.6.35-02063512-generic [OK]
> Trying kernel 2.6.34-02063410-generic [OK]
> Trying kernel 2.6.33-02063305-generic [OK]
> Trying kernel 2.6.32-02063255-generic [OK]
> Trying kernel 2.6.31-02063113-generic [OK]
> Trying kernel 2.6.30-02063010-generic [OK]
> Trying kernel 2.6.29-02062906-generic [OK]
> Trying kernel 2.6.28-02062810-generic [OK]
> Trying kernel 2.6.27-020627-generic [OK]
> Trying kernel 2.6.26-020626-generic [OK]
> Trying kernel 2.6.25-020625-generic [OK]
> Trying kernel 2.6.24-020624-generic [OK]
>
> Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>

Applied and pushed, thanks!

  Luis
