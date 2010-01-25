Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:52500 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab0AYRpQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 12:45:16 -0500
Received: by pwi21 with SMTP id 21so2397912pwi.21
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jan 2010 09:45:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100123123021.GA4261@home.pavel.comp>
References: <1264247654-21554-1-git-send-email-fercerpav@gmail.com>
	<20100123123021.GA4261@home.pavel.comp>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 25 Jan 2010 09:44:56 -0800
Message-ID: <43e72e891001250944s74c52369v63b6707ffa0bd872@mail.gmail.com>
Subject: Re: [PATCH] Implement runtime loading of RSA public keys
To: Paul Fertser <fercerpav@gmail.com>
Cc: linux-wireless@vger.kernel.org, 536502@bugs.debian.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 23, 2010 at 4:30 AM, Paul Fertser <fercerpav@gmail.com> wrote:
> On Sat, Jan 23, 2010 at 02:54:14PM +0300, Paul Fertser wrote:
>> +     if (!ok && (pubkey_dir = opendir(PUBKEY_DIR))) {
>> +             while (!ok && (nextfile = readdir(pubkey_dir))) {
>> +                     if ((keyfile = fopen(nextfile->d_name, "rb"))) {
>
> Duh, of course it's wrong but i managed to have that key in the
> current directory during testing :(
>
> Amended version attached.

Nice, thanks, applied.

  Luis
