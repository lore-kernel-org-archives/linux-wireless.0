Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38116 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab0JETOs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 15:14:48 -0400
Received: by iwn5 with SMTP id 5so8674848iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Oct 2010 12:14:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <698964.46316.qm@web56802.mail.re3.yahoo.com>
References: <1284325760-929-1-git-send-email-hauke@hauke-m.de> <698964.46316.qm@web56802.mail.re3.yahoo.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 5 Oct 2010 12:14:22 -0700
Message-ID: <AANLkTimoeXhYA7oV_iJxGCh_AVkoeAAyEYW0izUYU3aM@mail.gmail.com>
Subject: Re: [PATCH] compat-wireless: introduce driver-select group for atlxx
To: Walter Goldens <goldenstranger@yahoo.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 2, 2010 at 9:55 AM, Walter Goldens <goldenstranger@yahoo.com> wrote:
> In this patch:
> - fixed a description typo
> - changed yellow to purple color in bash as it hurts the eye/hard to read in white background (gnome)
> - placed "atl1 atl2 atl1e atl1c" on one line to preserve user space and visibility, this is after all a _wireless_ compat
> - introduced "atlxx" group for atlx(x) Ethernet devices in "BLUE" for distinguishability
> - sorted all module groups together
>
> Signed-off-by: Walter Goldens <goldenstranger@yahoo.com>

Applied, thanks!

  Luis
