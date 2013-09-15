Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ye0-f182.google.com ([209.85.213.182]:60896 "EHLO
	mail-ye0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab3IONu4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Sep 2013 09:50:56 -0400
Received: by mail-ye0-f182.google.com with SMTP id l10so1230476yen.41
        for <linux-wireless@vger.kernel.org>; Sun, 15 Sep 2013 06:50:55 -0700 (PDT)
Message-ID: <5235BB3B.5030800@lwfinger.net> (sfid-20130915_155059_760168_E788F9CC)
Date: Sun, 15 Sep 2013 08:50:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Olivier Reuland <olivier@reuland.ch>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL8192CU continually reconnecting
References: <CALa3VXYo1yTuDr22M7AUcp0WLQszzdMSJczRgmD57uPd_68vWQ@mail.gmail.com> <522D054B.5060205@lwfinger.net> <522DD856.7050309@ilande.co.uk> <522DE1BE.6070904@lwfinger.net> <522DE8CA.9010008@ilande.co.uk> <522DFF83.6000605@lwfinger.net> <loom.20130915T101439-276@post.gmane.org>
In-Reply-To: <loom.20130915T101439-276@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/15/2013 03:17 AM, Olivier Reuland wrote:
> Hi,
>
> I'm facing the same issue with a slightly different device: "ID 0b05:17ab
> ASUSTek Computer, Inc. USB-N13 802.11n Network Adapter (rev. B1) [Realtek
> RTL8192CU]". I'm also using Ubuntu, Saucy: "Linux desktop 3.11.0-7-generic
> #13-Ubuntu SMP Tue Sep 10 20:55:38 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux".

--snip--

>
> Let me know if there is anything I can do to help

There is a known problem with the dynamic power management code for this chip. 
Unfortunately, the problem does not affect my system. At the moment, my device 
that uses rtl8192cu has been connected for 12 hours with no disconnects. The 
only evidence of a bug here is poor performance.

Please describe your setup. What AP are you using? Is it an 802.11n or an 
802.11g connection? How far is your station from the AP? Are there any obstacles 
such as walls in the way? What is the signal strength as shown by iwconfig?

Larry

