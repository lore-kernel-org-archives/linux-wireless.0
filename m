Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f178.google.com ([209.85.220.178]:52117 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab3ILXCz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Sep 2013 19:02:55 -0400
Received: by mail-vc0-f178.google.com with SMTP id ha12so399032vcb.9
        for <linux-wireless@vger.kernel.org>; Thu, 12 Sep 2013 16:02:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5230CDF1.1040905@lwfinger.net>
References: <CALa3VXYo1yTuDr22M7AUcp0WLQszzdMSJczRgmD57uPd_68vWQ@mail.gmail.com>
	<522D054B.5060205@lwfinger.net>
	<522DD856.7050309@ilande.co.uk>
	<522DE1BE.6070904@lwfinger.net>
	<522DE8CA.9010008@ilande.co.uk>
	<522DFF83.6000605@lwfinger.net>
	<522E0573.4000804@ilande.co.uk>
	<522E1B7D.5010107@lwfinger.net>
	<522E463E.4040701@ilande.co.uk>
	<522E5416.4010901@lwfinger.net>
	<522E5D83.9060103@ilande.co.uk>
	<522E896E.7000607@lwfinger.net>
	<522EB51A.2080004@ilande.co.uk>
	<522F3757.8030600@lwfinger.net>
	<522F7B61.6060208@ilande.co.uk>
	<5230CDF1.1040905@lwfinger.net>
Date: Thu, 12 Sep 2013 19:02:54 -0400
Message-ID: <CALa3VXaY1WmvAY79Lnxu3ZpKp1MJeodzvija9BzjGA=w_4YgjA@mail.gmail.com> (sfid-20130913_010259_155471_74279361)
Subject: Re: RTL8192CU continually reconnecting
From: Timothy Rundle <tgrundlesr@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I finally got some free time to go through all the patches. My results
were similar to Mark's, but I do not get the watchdog messages, though
I am pretty sure watchdog is disabled on my PC. I did even try
installing openSUSE 12.3, but did not have any success.  It didn't
even find my wireless network. I manually configured the network via
network-manager, but still no luck.

Let me know if you need anything else from me.

On Wed, Sep 11, 2013 at 4:09 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 09/10/2013 03:04 PM, Mark Cave-Ayland wrote:
>
>> Interesting. Perhaps there is something different in the initial
>> programming of
>> the radio that causes it to crash on my particular hardware revision? As
>> before,
>> please let me know if there is anything else you require.
>
>
> From the log data, you have the same revision as I do.
>
> I am now running a kernel built with your configuration. I needed to make a
> couple of changes as it did not have one of the modules my disk system
> needs, and nouveau caused kernel panics, but we are now operational. Outside
> of the whole system being slow due to only one 2.0 GHz CPU, the wireless
> connection seems to be stable. At least, there have been no disconnects in
> the first half hour.
>
> Larry
>
>
