Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33440 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab1ADHJt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 02:09:49 -0500
Received: by gyb11 with SMTP id 11so5432653gyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jan 2011 23:09:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTinM9oPV=CJ3iUP2=fEH=+fRP5JPMO4tHLOZzHrS@mail.gmail.com>
References: <AANLkTinM9oPV=CJ3iUP2=fEH=+fRP5JPMO4tHLOZzHrS@mail.gmail.com>
Date: Tue, 4 Jan 2011 01:09:48 -0600
Message-ID: <AANLkTimPmCZ3O0WKe4OH1z4+rmtUtAr2wqsrFOUCJg_Q@mail.gmail.com>
Subject: Re: (rt61pci/hostapd) no packet activity when encryption is enabled
 and interface is bridged
From: C Anthony Risinger <anthony@extof.me>
To: linux-wireless@vger.kernel.org
Cc: C Anthony Risinger <anthony@extof.me>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 3, 2011 at 10:30 PM, C Anthony Risinger <anthony@extof.me> wrote:
>
> problem summary: an rt61pci driven card does not seem to allow any
> packets to enter/exit it's bridge ONLY WHEN ENCRYPTION is enabled;
> without it, everything works perfectly.

hmmmmm....

it would seem:

options rt61pci nohwcrypt=1

solves the problem.  what does this mean?  do i have a bad chip?
trying to determine if i need to exchange it; bought locally as a temp
card while i wait for my atheros USB b/g/n stick to have AP support
[ath9k_htc].

thanks,

C Anthony
