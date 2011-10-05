Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62400 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935480Ab1JEXOk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 19:14:40 -0400
Received: by iakk32 with SMTP id k32so2302904iak.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 16:14:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6VhgWws89upWaON_0FXmSnmyzsLSyO2S2fTfY2eYvwv4w@mail.gmail.com>
References: <CAFHVRfc1N8YNCmxMwsk1_UCZFQuOMNJE-9y31dnfcwrDsk36wA@mail.gmail.com>
	<CAB=NE6VhgWws89upWaON_0FXmSnmyzsLSyO2S2fTfY2eYvwv4w@mail.gmail.com>
Date: Wed, 5 Oct 2011 16:14:39 -0700
Message-ID: <CAFHVRfeL1NKXvTNHWNdD8T=UmBAcThnofhh6ATXgRVzt4pk81Q@mail.gmail.com> (sfid-20111006_011443_208230_F22CF057)
Subject: Re: Cannot make ath9k driver
From: Panu Avakul <avakulpa@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you very much for your reply,
I tried the compat-wireless-2011-09-27.tar.bz2 which is the latest one
I believed.
It still give me the same problem.
However,
I changed the ath.h file according to
https://dev.openwrt.org/changeset/28095
and it seems that now it works ok now.

Thank you very much.
Best Regards,
Panu Avakul

On Wed, Oct 5, 2011 at 4:05 PM, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:
> On Wed, Oct 5, 2011 at 3:57 PM, Panu Avakul <avakulpa@gmail.com> wrote:
>> Hello, I got the compat-wireless-2011-09-27
>
> Can you try today's release?
>
>  Luis
>
