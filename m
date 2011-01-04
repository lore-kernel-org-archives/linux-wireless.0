Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44728 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab1ADSiA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 13:38:00 -0500
Received: by mail-bw0-f46.google.com with SMTP id 15so14819122bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Jan 2011 10:37:59 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: C Anthony Risinger <anthony@extof.me>
Subject: Re: (rt61pci/hostapd) no packet activity when encryption is enabled and interface is bridged
Date: Tue, 4 Jan 2011 19:36:47 +0100
Cc: linux-wireless@vger.kernel.org
References: <AANLkTinM9oPV=CJ3iUP2=fEH=+fRP5JPMO4tHLOZzHrS@mail.gmail.com> <AANLkTimPmCZ3O0WKe4OH1z4+rmtUtAr2wqsrFOUCJg_Q@mail.gmail.com>
In-Reply-To: <AANLkTimPmCZ3O0WKe4OH1z4+rmtUtAr2wqsrFOUCJg_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201101041936.47573.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 4. Januar 2011 schrieb C Anthony Risinger:
> On Mon, Jan 3, 2011 at 10:30 PM, C Anthony Risinger <anthony@extof.me> wrote:
> >
> > problem summary: an rt61pci driven card does not seem to allow any
> > packets to enter/exit it's bridge ONLY WHEN ENCRYPTION is enabled;
> > without it, everything works perfectly.
> 
> hmmmmm....
> 
> it would seem:
> 
> options rt61pci nohwcrypt=1
> 
> solves the problem.  what does this mean?  do i have a bad chip?

I don't think so. Might be related to [1].

Helmut

[1] http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commit;h=fa8b4b22d543b4052602b0c86065150613ed19e8
