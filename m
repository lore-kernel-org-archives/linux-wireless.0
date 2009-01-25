Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:64709 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbZAYKoH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2009 05:44:07 -0500
Received: by nf-out-0910.google.com with SMTP id d3so939842nfc.21
        for <linux-wireless@vger.kernel.org>; Sun, 25 Jan 2009 02:44:06 -0800 (PST)
Message-ID: <497C4273.7050101@gmail.com> (sfid-20090125_114412_240655_4CAD8EC9)
Date: Sun, 25 Jan 2009 11:44:03 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Valentin <apo@apo2k4.ath.cx>
CC: linux-wireless@vger.kernel.org
Subject: Re: Fw: [linux-wireless] Re: p54 + ISL3887 + master mode?
References: <20090125020727.544a6819@lucien>
In-Reply-To: <20090125020727.544a6819@lucien>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Valentin wrote:
>>>> you probably want a kernel w/ at least this 
>>>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e5ea92a7528d304e8e327d0d261653e98b163e8a
>>>> hence 2.6.29+ or even newer to get the other p54 fixes.
>>> meant 2.6.28+, of course.

> That did help, thanks :) But it's not working completely yet:
> Any new ideas? Sorry if my questions are stupid...

Two things:

You may need a recent hostapd.

2.6.28 doesn't have a lot of fixes to p54, which are only in the
wireless-testing tree right now, so you may want to try that, or
wait until ~2.6.30, i guess.

fwiw i have a net2280 based p54usb device, that one works using
hostap from git and current wireless-testing kernels.

artur

