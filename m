Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:48240 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbZBGL37 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Feb 2009 06:29:59 -0500
Received: by bwz5 with SMTP id 5so231560bwz.13
        for <linux-wireless@vger.kernel.org>; Sat, 07 Feb 2009 03:29:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <c4d76b3b0902042003p7e2b28a0pcbf0953282becd27@mail.gmail.com>
References: <c4d76b3b0902042003p7e2b28a0pcbf0953282becd27@mail.gmail.com>
Date: Sat, 7 Feb 2009 13:29:57 +0200
Message-ID: <da94abde0902070329s373a9edbqd9265acac8930d2a@mail.gmail.com> (sfid-20090207_123004_004390_97CD91DC)
Subject: Re: [PATCH] at76_usb: fix Oops on disconnect
From: Kalle Valo <kalle.valo@iki.fi>
To: Jason Andryuk <jandryuk@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 5, 2009 at 6:03 AM, Jason Andryuk <jandryuk@gmail.com> wrote:
> flush_workqueue needs to be called instead of the generic one and the
> associated functions need to be modified to prevent re-adding
> themselves to the workqueue.

Good fix. Can you please port this to the at76c50x-usb driver I posted
this morning?

Kalle
