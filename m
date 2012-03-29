Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab2C2Jl5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2012 05:41:57 -0400
Date: Thu, 29 Mar 2012 11:40:57 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Matt Chen <machen@suse.com>
Cc: linville@tuxdriver.com, users@rt2x00.serialmonkey.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [rt2x00-users] [PATCH] rt2x00: rt2x00dev: move rfkill_polling
 register to proper place
Message-ID: <20120329094055.GC2351@redhat.com> (sfid-20120329_114200_777747_FAB534C9)
References: <1332829680-32457-1-git-send-email-machen@suse.com>
 <20120327123822.GA2565@redhat.com>
 <CALx5=V-aouK2ge3f2EQa07n2oJZRBXQGf15pXUdbsk6BjE+cdg@mail.gmail.com>
 <CALx5=V9++V8c-=Nu5X6rigkMcU5Lv6tgn9wn7DS4pwn4P0Yr-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CALx5=V9++V8c-=Nu5X6rigkMcU5Lv6tgn9wn7DS4pwn4P0Yr-A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 29, 2012 at 10:50:25AM +0800, Matt Chen wrote:
> Hi John,
> 
> Would it be possible to merge my patch to v3.4 merging ？
> It would be great if this patch got merged. This patch fixes an
> initialization of probing pci device. Since a lot users reported the
> issue is making no sense after rebooting the machine and got No
> wireless device working due to rfkill is not yet started to work.
> 
> Thank you for your kindly help. :)
> 
> Would it be possible to merge this patch into v3.4 tree before the
> merging window closed ?
Since patch is a fix, it could be applied after merge window. But first
you should fix sign-off's and repost.

Stanislaw
